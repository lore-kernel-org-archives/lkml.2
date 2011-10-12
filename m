Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab1JLR6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 13:58:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45963 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751855Ab1JLR6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 13:58:19 -0400
Date: Wed, 12 Oct 2011 18:58:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cy82c693: fix PCI device selection
Message-ID: <20111012185821.2955b861@lxorguk.ukuu.org.uk>
In-Reply-To: <201110121652.10495.bzolnier@gmail.com>
References: <201110111937.32501.bzolnier@gmail.com>
	<20111011.152040.662786307819949300.davem@davemloft.net>
	<201110121652.10495.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011 16:52:10 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> David Miller wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Date: Tue, 11 Oct 2011 19:37:32 +0200
> > 
> > > While at it remove redundant pci_get_slot() call as cy82c693_init_one()
> > > already takes care of keeping the reference on the second port's PCI
> > > device.
> > 
> > Please do not submit unrelated changes with a bug fix, and as IDE is
> > in long-term maintainence I would not accept a risky refinement like
> > this anyways.
> 
> Removed code is just bogus, we cannot fail in ->set_pio_mode method.
> 
> Please take a look at the code:
>  
> -	/* select primary or secondary channel */
> -	if (hwif->index > 0) {  /* drive is on the secondary channel */
> -		dev = pci_get_slot(dev->bus, dev->devfn+1);
> -		if (!dev) {
> -			printk(KERN_ERR "%s: tune_drive: "
> -				"Cannot find secondary interface!\n",
> -				drive->name);
> -			return;
> -		}
> -	}
> 
> Please apply the patch, libata's pata_cypress doesn't support secondary
> port currently and cy82c693 driver is the only way to use this hardware.

I've not found anyone using an Alpha 164SX in years so it's not been
possible to do the updates and test them. And no ... do not offer to send
me an Alpha, donate it to a museum.

Alan
