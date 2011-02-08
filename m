Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab1BHNeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:34:36 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48232 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753539Ab1BHNef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:34:35 -0500
Date: Tue, 8 Feb 2011 13:38:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/20] ata_piix: add EFAR SLC90E66 support
Message-ID: <20110208133809.2386ee86@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTikYXWAbCjLpSyEqgDKBsZuM1na-tohLoLJx3Yr4@mail.gmail.com>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
	<20110208122534.19110.89437.sendpatchset@linux-mhg7.site>
	<20110208131321.6ceb9a43@lxorguk.ukuu.org.uk>
	<AANLkTikYXWAbCjLpSyEqgDKBsZuM1na-tohLoLJx3Yr4@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> such optimizations because maintenance cost > potential savings (i.e.
> making SCSI quirks optional, I have draft patch for this, itself cuts
> like 10k).

Interesting in itself but irrelevant because the current situation is
that a piix change cannot break oldpiix, efar, it8213, radisys etc and
vice versa. Particuarly important when the other chips are not common so
test coverage is difficult, and that far outweighs the maintenance
savings for other things, especially as this is code that just doesn't
change.

> 
> > It also leads to hideous uglies in the main code paths like this :
> >
> > +       unsigned int has_sitre  = (dev->vendor != 0x8086 ||
> > +                                  dev->device != 0x1230);
> >
> > which also has exactly zero comments.
> 
> has_sitre variable name is documentation in itself for anyone knowing
> the hardware or has read a chipset/code documentation.

And naturally anyone randomly glancing at the code knows why it's
checking 0x8086 & 0x1230, and why the radisys check interacts with it.

Bartlomiej - those are a mess, a complete and total mess. It doesn't
necessarily argue against folding them together, but at least do a clean
job of it.
