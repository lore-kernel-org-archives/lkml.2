Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab1BTLfL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 06:35:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47544 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751168Ab1BTLfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 06:35:08 -0500
Date: Sun, 20 Feb 2011 11:36:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 05/20] pata_efar: always program master_data before
 slave_data
Message-ID: <20110220113613.105a08e4@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=Lj54hRfkn7qLwoQ7aGSchnzBwy4m2Uok764qD@mail.gmail.com>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
	<20110208122409.19110.4233.sendpatchset@linux-mhg7.site>
	<20110208130701.19709cc6@lxorguk.ukuu.org.uk>
	<AANLkTimAioh_xu0qoQCndSWDAYJ4bpWv01NZn_bZ9g2a@mail.gmail.com>
	<20110208132518.300bb098@lxorguk.ukuu.org.uk>
	<4D514754.30203@ru.mvista.com>
	<AANLkTinE5x=hmQ6Oykw3Tb38HVeL5eHxjdnPOdMt930q@mail.gmail.com>
	<20110219164811.2e90de88@lxorguk.ukuu.org.uk>
	<AANLkTi=Lj54hRfkn7qLwoQ7aGSchnzBwy4m2Uok764qD@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>         idetm_data |= 0x4000;   /* Ensure SITRE is set */
>         pci_write_config_word(dev, idetm_port, idetm_data);
> 
> idetm_port needs to be programmed _before_ slave_data to "ensure SITRE is set".

That isn't what the documentation seems to say. It says it has no effect
unless SITRE is set not that you can't program the registers.

> Unless they are obvious or risk is higher than benefit (bugfixes based
> on code review).  I don't think that ATA code has became recently
> special in this regard compared to the rest of the kernel.

They aren't special - random unneeded code changes that haven't been
tested shouldn't be going into the code unless there is a big gain. For
obscure ancient devices there isn't a gain.

>      ata_piix: unify code for programming PIO and MWDMA timings

Which as I said makes sense

>      pata_efar: fix register naming used in efar_set_piomode()
>      pata_efar: unify code for programming PIO and MWDMA timings
>      pata_efar: always program master_data before slave_data

All untested

>      pata_it8213: fix register naming used in it8213_set_piomode()
>      pata_it8213: unify code for programming PIO and MWDMA timings
>      pata_it8213: add UDMA100 and UDMA133 support

All untested

>      pata_oldpiix: unify code for programming PIO and MWDMA timings

Untested

>      pata_radisys: unify code for programming PIO and MWDMA timings

Untested

>      pata_rdc: unify code for programming PIO and MWDMA timings
>      pata_rdc: parallel scanning needs an extra locking
>      pata_rdc: add Power Management support

All untested but the locking is a clear bug fix and I think should go in

>      pata_oldpiix: add locking for parallel scanning
>      pata_oldpiix: enable parallel scan

This is an ancient device on some old pentium class boxes, it's not
worth adding this stuff really is it ? Well maybe putting the locking in
or at least comments that it will be needed ?

> Most patches has been posted months ago in the past as the part of
> atang tree.

So - where are the test reports

> * pata_it8213: IDE -> libata regression fix (UDMA100/133 support based
> on vendor / old IDE driver)

I didn't see it tested in the old IDE driver either.

> * pata_oldpiix: locking bug-fix (ACK-ed by you in the past) and
> parallel scanning support

I'm happy with the locking fix, I don't see the point in the parallel
scan - and that wants testing because I don't know how the hardware will
react. Most controllers were not designed for parallel scan and its a
path windows will never have exercised therefore may well never have been
tested out.

In the PIIX4+ cases Jeff insisted we chased this down with the hardware
folks in Intel to be sure it was ok. I'm not sure there is anyone who
remembers original PIIX however.

> I see a lot of magnitude more risky stuff going elsewhere in the
> kernel, including ATA itself

And being tested.

efar/it8213/radisys are going to be tricky to find testers for as they
are rare chips but the RDC is found in some of the embedded
CPU/ATA/Net/etc in a device embedded x86 devices.

Alan
