Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab2ACQGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 11:06:09 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49545 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab2ACQGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 11:06:07 -0500
Date: Tue, 3 Jan 2012 16:06:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: serial ports now asserting DTR and RTS during boot; breaks
 connected hardware
Message-ID: <20120103160655.69107c93@pyramind.ukuu.org.uk>
In-Reply-To: <20120103153707.GA12771@redhat.com>
References: <20120103153707.GA12771@redhat.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jan 2012 10:37:07 -0500
Dave Jones <davej@redhat.com> wrote:

> Jiri,
> We got this report from a user who notes a change in behaviour for
> his serial hardware over the last few kernel versions.
>  
> https://bugzilla.redhat.com/show_bug.cgi?id=771010
> 
> This sounds like it might be related to your DTR/RTS changes back in March 2011 maybe ? 

Looks like your userspace to me at first glance.

ftdi_sio sets up the modem lines in set_termios. Set_termios is called
from ftdi_open. ftdi_open is triggered by userspace.

>  > The following code in the ftdi_sio driver is one suspect but this behavior
>  > happens on 8250 UARTs also so it is systemic now,

Likewise 8250 sets up the lines in serial8250_startup. This is called via
uart_startup which is called via open.

I think a necessary first step would be to test a current kernel on FC14,
or boot a sane simple kernel and test image and see what that does so all
the udev and system startup stuff can be eliminated. Wouldn't surprise me
at all however if something like udev triggered poking around for UPS
devices or 3G modems wasn't the trigger ?

Alan
