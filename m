Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab1HaNEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:04:30 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:50083
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755605Ab1HaNE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:04:28 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz9371K1432N98dKzz1202hzz15d4R8275bhz32i668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQSMX4-02-0O3-02
X-M-MSG: 
Date: Wed, 31 Aug 2011 15:03:04 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] iommu: Remove stub functions for !CONFIG_IOMMU_API
Message-ID: <20110831130304.GP12940@amd.com>
References: <1314364839-28492-1-git-send-email-joerg.roedel@amd.com>
 <CAK=WgbaiNxo_226Zp9BZpgUjYFajnvgPPCjCOYP2Tj4pkWTwVA@mail.gmail.com>
 <20110829101550.GT1923@amd.com>
 <CADMYwHwZPiH12HxOP952-Znm_+uMXKpj2M6ew8W-frZ7R8EcWg@mail.gmail.com>
 <20110829122516.GB9730@amd.com>
 <CAK=WgbbqCL60uf9gWhLYbkJo44Sva3BwQuZk2R--ER4M+yDV2w@mail.gmail.com>
 <20110829130552.GA10422@amd.com>
 <CAK=WgbagTUqZhPkg8OnVEvF2EB=AnpgfV5Fs0g95+o1mVU47YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK=WgbagTUqZhPkg8OnVEvF2EB=AnpgfV5Fs0g95+o1mVU47YQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 09:21:54AM -0400, Ohad Ben-Cohen wrote:
> On Mon, Aug 29, 2011 at 4:05 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> > So in this case you can skip this whole part when CONFIG_IOMMU_API is
> > disabled
> 
> Sure, we can do something like this in the driver:
> 
> #ifdef CONFIG_IOMMU_API
> 
> int do_the_iommu_thing(..)
> {
>    ... call the IOMMU API as needed...
> }
> 
> #else
> 
> int do_the_iommu_thing(..)
> {
>     return 0;
> }
> 
> #endif
> 
> Essentially, this means implementing the !CONFIG_IOMMU_API stubs in the driver.

I expect only very few drivers need that. Most drivers (like KVM and the
upcoming VFIO) rely on the iommu-api and I expect most other drivers
using the directly will also rely on an iommu. So this change makes
still sense to me.

> Possible of course, but I think it's a bit neater to have that in one
> place, where all drivers can use. Similar to !CONFIG_HWSPINLOCK,
> !CONFIG_DEBUG_FS, ...
> 
> > This saves you even more .text size, no?
> 
> Not sure; I expect the code to be compiled out today when the IOMMU
> API is called and CONFIG_IOMMU_API is not set.

But you even save all code that would use the iommu-api in your driver.
This change forces you to compile out this code too leading to smaller
.text-size.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

