Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab1IMKol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:44:41 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:38712
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356Ab1IMKoj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:44:39 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz9371K1432N98dKzz1202hzz15d4R8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRGJ68-01-28W-02
X-M-MSG: 
Date: Tue, 13 Sep 2011 12:44:33 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Brown <davidb@codeaurora.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH 3/3] iommu/core: split mapping to page sizes as supported
 by the hardware
Message-ID: <20110913104433.GL11701@amd.com>
References: <1315421604-12286-1-git-send-email-ohad@wizery.com>
 <1315421604-12286-3-git-send-email-ohad@wizery.com>
 <20110913101011.GK11701@amd.com>
 <CAK=WgbbhdFpAHTt=Bku-v1ZOCf48+u+XB-f4yO=5EDojv1kCJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CAK=WgbbhdFpAHTt=Bku-v1ZOCf48+u+XB-f4yO=5EDojv1kCJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 06:34:23AM -0400, Ohad Ben-Cohen wrote:
> Hi Joerg,
> 
> On Tue, Sep 13, 2011 at 1:10 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> > Please split this patch into the core-change and patches for the
> > individual iommu-drivers and post this as a seperate patch-set.
> 
> But we'll be breaking bisectibility this way, no?

Not necessarily. You could implement this side-by-side with the old code
until all drivers are converted and remove the old code then. This keeps
bisectability.

> > Intel IOMMU does not support arbitrary page-sizes, afaik.
> 
> It does; besides the usual 4K it has "super page sizes" support of
> 2MB, 1GB, 512GB and 1TB.

But the value ~0xfffUL indicates support for 4k, 8k, 16k .. 2^63, no?

> 
> >> +       pr_debug("map: iova 0x%lx pa 0x%lx size 0x%lx\n", iova,
> >> +                                       (unsigned long)paddr, size);
> >
> > Please keep the debug-code in a seperate patch in your dev-tree. No need
> > for it to be merged upstream.
> 
> It's actually useful sometimes to have those around - it's off by
> default, and can be enabled only when needed (CONFIG_DYNAMIC_DEBUG).
> 
> But I don't mind removing them.

Ah right, it is just debug, so I am fine keeping it.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

