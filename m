Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab1IIBi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:38:29 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:53038 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758115Ab1IIBi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:38:26 -0400
Date: Fri, 9 Sep 2011 09:38:18 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 61/62] Documentation: irq: Change documents related to
 IRQF_DISABLED
Message-ID: <20110909013818.GC18249@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
 <1315383059-3673-62-git-send-email-yong.zhang0@gmail.com>
 <4E6935D9.1040104@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E6935D9.1040104@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 02:38:33PM -0700, Randy Dunlap wrote:
> On 09/07/11 01:10, Yong Zhang wrote:
> > IRQF_DISABLED is a NOOP now, place where suggest to use this
> > flag also doesn't make sense anymore.
> > 
> > Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> > ---
> >  Documentation/PCI/MSI-HOWTO.txt  |   21 ---------------------
> >  Documentation/scsi/ncr53c8xx.txt |    4 +++-
> >  Documentation/scsi/tmscsim.txt   |    4 ++--
> >  3 files changed, 5 insertions(+), 24 deletions(-)
> 
> > diff --git a/Documentation/scsi/ncr53c8xx.txt b/Documentation/scsi/ncr53c8xx.txt
> > index cda5f8f..654b34c 100644
> > --- a/Documentation/scsi/ncr53c8xx.txt
> > +++ b/Documentation/scsi/ncr53c8xx.txt
> > @@ -786,7 +786,9 @@ port address 0x1400.
> >          irqm:1     same as initial settings (assumed BIOS settings)
> >          irqm:2     always totem pole
> >          irqm:0x10  driver will not use IRQF_SHARED flag when requesting irq
> > -        irqm:0x20  driver will not use IRQF_DISABLED flag when requesting irq
> > +        irqm:0x20  driver will not use IRQF_DISABLED(Does not make sense
> > +		   anymore since genirq will keep irq disabled and the flag
> 
>                              will not use IRQF_DISABLED (does not make sense
>                    any more

Updated.

> 
> > +		   is dead from linux-2.6.36) flag when requesting irq

			Ah, should be linux-2.6.35 here.

> >  
> >      (Bits 0x10 and 0x20 can be combined with hardware irq mode option)
> >  
> > diff --git a/Documentation/scsi/tmscsim.txt b/Documentation/scsi/tmscsim.txt
> > index 61c0531..45cfd63 100644
> > --- a/Documentation/scsi/tmscsim.txt
> > +++ b/Documentation/scsi/tmscsim.txt
> > @@ -108,8 +108,8 @@ MHz PCI bus works for me, though, but I don't recommend using higher clocks
> >  than the 33.33 MHz being in the PCI spec.
> >  
> >  If you want to share the IRQ with another device and the driver refuses to
> > -do so, you might succeed with changing the DC390_IRQ type in tmscsim.c to 
> > -IRQF_SHARED | IRQF_DISABLED.
> > +do so,  you should find out what's the mismatch between the shared irqs,
> 
>    do so, you should                                                  IRQs,

Updated.

Thanks Randy.

	Yong
