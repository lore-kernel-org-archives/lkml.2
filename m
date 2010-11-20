Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab0KTNFQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 08:05:16 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47269 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752797Ab0KTNFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 08:05:14 -0500
Date: Sat, 20 Nov 2010 13:04:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: ide boot failure 2.6.36/2.6.28 - 2.6.27 works
Message-ID: <20101120130401.59d8b8a1@lxorguk.ukuu.org.uk>
In-Reply-To: <20101120121121.GA30338@iq>
References: <20101120032828.GA14693@iq>
	<20101120074508.GA16854@liondog.tnic>
	<20101120121121.GA30338@iq>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The author of the regression knew that he was breaking some setups
> and cleared his conscience by adding a printk
> +   printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
> +   	     	       "parameter for probing all legacy ISA IDE ports\n");
> at boot time. Of course this scrolls off the screen too quickly to read.

I pointed out at the time that this was totally bogus hackery, but
without result. On a PCI box however you should always have a matching
PCI driver, and if not you want to force ide-generic to bind to it in
almost all cases, so if its hitting a lot of people then something else
is wrong in the config choices of the distro

The libata driver tries to be a bit smarter, firstly by not leaking
random resources but also knows not to bind against ports mapped to PCI
devices, or to certain special cases (non PCI standard but PCI space
using) devices.

If you have a PCI ATA driver which is not handled by any of the libata
drivers and is not known by ata_generic then please let me know. I
think we have pretty much everything old, weird and wonderful covered in
libata.

Alan
