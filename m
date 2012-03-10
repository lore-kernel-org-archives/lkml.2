Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab2CJTtL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 14:49:11 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33894 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2CJTtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 14:49:08 -0500
Date: Sat, 10 Mar 2012 19:51:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lkcl luke <luke.leighton@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>
Subject: Re: [advice sought] EOMA68 kernel support
Message-ID: <20120310195105.6d301bd5@pyramind.ukuu.org.uk>
In-Reply-To: <CAPweEDx3ktAgz9vdM+E-c5YZGrbBMbX4TOy+QUHV3mRM28oWRw@mail.gmail.com>
References: <CAPweEDz+seEGbAtE48NfPon66jqvb0sNSMcnC-LnXvmVbF+sbA@mail.gmail.com>
	<CAPweEDysGTCNp+6SCCpzBorwn5ZczNNgV0E+mBLe0FwfE=3Wqw@mail.gmail.com>
	<20120310130055.5bd5263a@pyramind.ukuu.org.uk>
	<CAPweEDx3ktAgz9vdM+E-c5YZGrbBMbX4TOy+QUHV3mRM28oWRw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  of particular concern is that a CPU card could be running on (small!)
> backup battery / supercapacitor whilst being hot-swapped, and thus
> that means that the LCD module (drivers/eoma68/lcd.ko?) would need to
> be loaded and unloaded from userspace (udev).  that's not going to be
> a problem, is it?  i may just be imagining skeletons in the closet,
> here.

Your device tree describes devices. Your bus creates them when you
hotplug and it removes them when you hot unplug. The rest is the drivers
problem to behave properly, and refcount right.

>  * it's the purposes to which the 16 GPIOs can be put that will be
> radically different from one I/O board to the next.  GPIO 0 could be
> "powerup for WIFI" on one I/O board, but "lid open/shut switch" on
> another.

It's "GPIO 0 of card X" and providing you remember that, watch your
refcounting and don't remap a new device over the address space of an old
one during a hotplug you should be fine.

Alan
