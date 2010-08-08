Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab0HHXvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 19:51:33 -0400
Received: from n3-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.157]:39604 "HELO
	n3-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755020Ab0HHXvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 19:51:32 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 186880.12360.bm@omp121.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=YYI0JKWmDFDGoIapW9hMFRER5PUJpSm5SEDHzwomvSxe46aVuPIEpa2pJ/d2eXEtSbXiA2Wu5co1Px16o0XIwmKQawnV/FEd+uYnKpFTRumSzrGI4fun7jG+SEYB9h94AjzfW0mC28dctQ2v6KksGfh4i75nHibQtnaSF2uNxFo=;
Message-ID: <94927.80688.qm@web180312.mail.gq1.yahoo.com>
X-YMail-OSG: PrNUyesVM1m93CUltFhFeGg8x3g3d4..wvWXEzqYlfs8klb
 Uqy9BB8K_2xMK7Z_Mp.f8ULozr_GSZe0JzxRS48jxMTcaa.5rjxCwYubEGDT
 9U7JqBfdSaiNGUJzTZa9LBHOxXi2dzI14Ule.w.WiayaZBjdtkwoWZBDrbW0
 4puuouakj3l_66mFbfvHTi1SEE48r2EeY3f56OfJHvgA0QP12uK0Kum2WzMy
 lh_rOf0lr.CkZ.6Xb386wTUdGXImsbC2u2CtXABtSdBMA9AE3dLNd1GMK5kw
 CbFMiKiMA2DpqFHb5ADzw_Xldio0OxRyiGo8dKmM-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sun, 8 Aug 2010 16:51:30 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2] mfd: add TPS6586x driver
To: Mike Rapoport <mike.rapoport@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Mike Rapoport <mike@compulab.co.il>, Jean Delvare <khali@linux-fr.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100808222636.GC3480@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I've left the GPIO code in the driver because of
> > * David prefers to keep GPIO part of MFD devices in
> the drivers/mfd ( [1] )
> I think that's arguable for many reasons. A
> couple of them being that there
> are already several MFD GPIO subdevices there
> and that at least one of those
> has been authored by David itself.
> So that's certainly not a generic assumption. David, I
> would agree that the
> gpio code from Mike below is small enough (although it's
> probaly going to grow
> over time...) to stay withing the MFD driver,

I'd certainly prefer that.


> but what's your "policy" for
> accepting/rejecting GPIO drivers
> in drivers/gpio/ ?

I prefer drivers/GPIO code to be standalone chips
and SOC/ASIC/MFD GPIO support to stick together.

Classic example:  arch/arm/... almost every SOC
has its own GPIO support coupled with the rest
of its core code (GPIOs being widely used as IRQ
support, which is also core support). 


I prefer not seeing support for one chip end up
scattered throughout the source tree.  When one
of  the "sub-drivers" is very complicated (audio
and video come to mind) I object less, but that
kind of scattering still seems worth avoiding.

Some of Intel's platform chips aren't supported in
what I'd call very clean ways -- they're scattered,
with GPIO fragments in drivers/gpio (where I would
rather they not live, but I have no current notion
of better homes, lacking one directory tying all of
those MFD/SOC/Southbridge/... things together.

- Dave


- Dave



