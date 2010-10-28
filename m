Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113Ab0J2QL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 12:11:59 -0400
Received: from dsl-fixed-62-69-39-101.surfdsl.murphx.net ([62.69.39.101]:57946
	"EHLO localhost6.localdomain6" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755308Ab0J2QL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 12:11:56 -0400
X-Greylist: delayed 2264 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Oct 2010 12:11:55 EDT
Date: Thu, 28 Oct 2010 23:11:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Timur Tabi <timur@freescale.com>, gregkh <gregkh@suse.de>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Writing a console/tty driver -- how to use tty_port?
Message-ID: <20101028231129.55b29420@pyx>
In-Reply-To: <201010282257.33898.arnd@arndb.de>
References: <4CC893CD.7020701@freescale.com>
	<201010282257.33898.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; i686-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Oct 2010 22:57:33 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 27 October 2010 23:04:13 Timur Tabi wrote:
> > Do you have an updated version of Tiny TTY that uses tty_port structures?  I'm
> > trying to write a new TTY driver for a device that is not a UART, and I'm having
> > a hard time finding a good example.  I suspect I need to understand the tty_port
> > structure, but I can't find any documentation for it.
> 
> If the device is not a UART, the best option may be to make the driver
> a backend to the hvc driver, like e.g. drivers/char/hvc_tile.c.
> 
> This works for all devices with or without interrupts that don't need
> to set up the communication parameters but simply provide a read/write
> character interface.

I really don't understand the love of hvc when the hvc drivers seem to be
bigger than native tty_port code and haul a whole blob of extra midlayer
glue into the system.

