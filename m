Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab1DLGe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 02:34:26 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.183]:39857
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755123Ab1DLGeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 02:34:24 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4Rz32i637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJJ0V7-02-DOF-02
X-M-MSG: 
Date: Tue, 12 Apr 2011 08:33:05 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86/amd-iommu: Add extended feature detection
Message-ID: <20110412063305.GB20607@amd.com>
References: <1302514324-14717-1-git-send-email-joerg.roedel@amd.com>
 <1302514324-14717-2-git-send-email-joerg.roedel@amd.com>
 <4bd170057af715738bbc818219dffc04.squirrel@webmail.sf-mail.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4bd170057af715738bbc818219dffc04.squirrel@webmail.sf-mail.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 11:11:44AM -0400, Rolf Eike Beer wrote:
> > This patch adds detection of the extended features of an
> > AMD IOMMU. The available features are printed to dmesg on
> > boot.
> 
> > diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> > index bcf58ea..d609610 100644
> > --- a/arch/x86/kernel/amd_iommu.c
> > +++ b/arch/x86/kernel/amd_iommu.c
> > @@ -29,8 +29,8 @@
> >  #include <asm/proto.h>
> >  #include <asm/iommu.h>
> >  #include <asm/gart.h>
> > -#include <asm/amd_iommu_proto.h>
> >  #include <asm/amd_iommu_types.h>
> > +#include <asm/amd_iommu_proto.h>
> >  #include <asm/amd_iommu.h>
> 
> That one (and the second place where this happens later) look suspicious.
> Do you need that change? Usually those includes tend to be alphabetically
> sorted (which you destroy here).
> 
> When you _need_ that change that means that you probably use some things
> from amd_iommu_types.h in amd_iommu_proto.h without including that header
> there (which is a bug in amd_iommu_proto.h and must be fixed there).
> Otherwise this change is just noise. So either way this change should not
> happen IMHO.

Yeah, this is not very good style, I agree with that. In this case the
amd_iommu_proto.h file got a new inline function which needs the struct
amd_iommu.

I have merging of the different include files for the AMD IOMMU driver
on my cleanup list. There are currently 3 include files which seems a
bit too much. A single one will do too. Meanwhile I change this patch so
that amd_iommu_proto.h will include amd_iommu_types.h itself. This
doesn't make it nice and clean but at least less ugly meanwhile ;)

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

