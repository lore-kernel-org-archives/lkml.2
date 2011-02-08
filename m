Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1BHOJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 09:09:08 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38893 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754416Ab1BHOJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 09:09:06 -0500
Date: Tue, 8 Feb 2011 14:12:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/20] pata_efar: always program master_data before
 slave_data
Message-ID: <20110208141239.28d80615@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTik744+r8y1FK9P6-aOcH0OMLyg5nvfJb2ZBVSdv@mail.gmail.com>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
	<20110208122409.19110.4233.sendpatchset@linux-mhg7.site>
	<20110208130701.19709cc6@lxorguk.ukuu.org.uk>
	<AANLkTimAioh_xu0qoQCndSWDAYJ4bpWv01NZn_bZ9g2a@mail.gmail.com>
	<20110208132518.300bb098@lxorguk.ukuu.org.uk>
	<AANLkTimYbC+zgnct9j75WNR7f4M4m2=hYvODUm9mc-3W@mail.gmail.com>
	<20110208133922.6cf8142e@lxorguk.ukuu.org.uk>
	<AANLkTik744+r8y1FK9P6-aOcH0OMLyg5nvfJb2ZBVSdv@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> respect some of my time spent on all this burdensome silly little
> driver differences comparisons and read the whole patch set before
> making comments on individual changes (which you certainly haven't
> done given timing of your review mails and complexity of changes)..

I was hoping you'd improved but apparently not.

Any untested change is dangerous. An untested change that merges drivers
together simply means you can break lots of stuff for no gain at all.

If these were all PCI card devices it might make some sense but given
they are all motherboard chipsets putting them into one driver merely
increases memory use as well.

As far as stuff like 

   unsigned int has_sitre  = (dev->vendor != 0x8086 ||
                                  dev->device != 0x1230);

and the even worse mess you generate with the added patch all the other
PIIX code does this by flags, and if you had a HAS_SITRE (or NO_SITRE)
flag in the device data it would be obvious to anyone reading stuff how
it all fitted together.

Alan


