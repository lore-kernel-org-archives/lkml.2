Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab2HJT3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 15:29:20 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41049 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab2HJT3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 15:29:18 -0400
Date: Fri, 10 Aug 2012 20:33:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stas Sergeev <stsp@list.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Subject: Re: Q: how to control the TTY output queue in real time?
Message-ID: <20120810203355.224622cc@pyramind.ukuu.org.uk>
In-Reply-To: <50255E31.8060904@list.ru>
References: <50255E31.8060904@list.ru>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am writing an app that needs to control the
> serial xmit in real-time. What I need is a notification
> that the TTY output queue fillup (returned by TIOCOUTQ
> ioctl) have dropped below the specified value.

Not a supported feature basically.

> I haven't found anything that can help implementing
> this. If I can't get an async notification, the sync
> notification will do too, like, for instance, the tcdrain()
> call, but with the argument to specify the needed fillup,
> below which the function will return.
> If there is nothing like this, then even the notification
> on every transmitted char will do.
> But I've found nothing of the above. :(
> 
> Any suggestions how the real-time control can be
> implemented?

Bascially even on the hardware that knows with this degree of granularity
we don't propogate the information back in the manner you want.

I'm not sure its a total loss however. Currently all the code basically
does stuff in the tx path or tx irq handler along the line of


	if (bytes_left < constant)
		write_wakeup


and I suspect if you made that adjustable and turned off the fifo and any
other funnies you'd at least make it work for a sufficiently rigged demo.

We could in theory put it in the tty_port in future too if its general
purpose useful.

Alan
