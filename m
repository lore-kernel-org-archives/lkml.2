Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab1I0V7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:59:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56572 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751890Ab1I0V7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:59:46 -0400
Date: Tue, 27 Sep 2011 22:57:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Darren Hart <dvhart@linux.intel.com>
Cc: "lkml, " <linux-kernel@vger.kernel.org>,
        Denis Turischev <denis@compulab.co.il>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: Serial issues with EG20T (Topcliff) PCH uarts
Message-ID: <20110927225722.54936878@lxorguk.ukuu.org.uk>
In-Reply-To: <4E820FA8.8050604@linux.intel.com>
References: <4E820FA8.8050604@linux.intel.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Using the ti_usb_3410_5052 driver with modified vendor/product strings, I am
> able to get ttyUSB0 on my host and open it in minicom:
> 
> $ sudo modprobe ti_usb_3410_5052 vendor_3410=0x0451 product_3410=0x5053
> $ minicom -D /dev/ttyUSB0

Please submit those idents to GregKH for the ti_usb driver.

> Can anyone offer up some ideas on what I might try to get:
> 
> 1) the getty working
> 2) the earlier kernel messages to appear
> 3) syslinux working
> 
> over the serial port?

It may depend a lot on the port. If it boots in PCI D3 (power saved) then
it's going to be fun. Otherwise forcing the address of the port ought to
do the trick.

See	
	console=uart8250,io 0xb060,115200n8

although it's polled so you may want to drop the speed a bit!

netconsole might also be useful to debug the early serial problems !

No idea for syslinux.

Alan
