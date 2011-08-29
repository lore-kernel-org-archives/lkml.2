Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab1H2NH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:07:57 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:32884
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218Ab1H2NHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:07:53 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz9371K1432N98dKzz1202hzz15d4R8275bhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQOXPU-01-AU8-02
X-M-MSG: 
Date: Mon, 29 Aug 2011 15:05:52 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] iommu: Remove stub functions for !CONFIG_IOMMU_API
Message-ID: <20110829130552.GA10422@amd.com>
References: <1314364839-28492-1-git-send-email-joerg.roedel@amd.com>
 <CAK=WgbaiNxo_226Zp9BZpgUjYFajnvgPPCjCOYP2Tj4pkWTwVA@mail.gmail.com>
 <20110829101550.GT1923@amd.com>
 <CADMYwHwZPiH12HxOP952-Znm_+uMXKpj2M6ew8W-frZ7R8EcWg@mail.gmail.com>
 <20110829122516.GB9730@amd.com>
 <CAK=WgbbqCL60uf9gWhLYbkJo44Sva3BwQuZk2R--ER4M+yDV2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK=WgbbqCL60uf9gWhLYbkJo44Sva3BwQuZk2R--ER4M+yDV2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 08:55:40AM -0400, Ohad Ben-Cohen wrote:
> On Mon, Aug 29, 2011 at 3:25 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> > Right, when the system has an iommu then the iommu-api is the right
> > choice to do that. But how to you handle this on systems without an
> > iommu?
> 
> On iommu-less systems this is completely moot, as the remote processor
> can access the bus directly, and thus doesn't need any iommu
> configuration to take place before it boots.
> 
> So in case there is an iommu - we configure it appropriately, and if
> there isn't, we just skip that part.

So in this case you can skip this whole part when CONFIG_IOMMU_API is
disabled (just don't compile the code in that requires the iommu-api).
This saves you even more .text size, no?

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

