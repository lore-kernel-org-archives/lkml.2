Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab2GFMYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:24:05 -0400
Received: from mail-db3.bigfish.com ([94.245.120.74]:16169 "EHLO
	DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750786Ab2GFMYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 08:24:03 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jul 2012 08:24:03 EDT
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -14
X-BigFish: VPS-14(zz98dI936eI1432I4015Izz1202hzz15d4Rz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M6QN24-01-ETE-02
X-M-MSG: 
Date: Fri, 6 Jul 2012 14:08:24 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Joe Perches <joe@perches.com>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/28] iommu/amd: Move informational prinks out of
 iommu_enable
Message-ID: <20120706120824.GA2639@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
 <1341491808-23083-7-git-send-email-joerg.roedel@amd.com>
 <1341547718.27760.5.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1341547718.27760.5.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Thu, Jul 05, 2012 at 09:08:38PM -0700, Joe Perches wrote:
> On Thu, 2012-07-05 at 14:36 +0200, Joerg Roedel wrote:
> > +	static const char * const feat_str[] = {
> > +		"PreF", "PPR", "X2APIC", "NX", "GT", "[5]",
> > +		"IA", "GA", "HE", "PC", NULL
> > +	};
> > +	struct amd_iommu *iommu;
> > +
> > +	for_each_iommu(iommu) {
> > +		int i;
> > +		pr_info("AMD-Vi: Found IOMMU at %s cap 0x%hx\n",
> > +			dev_name(&iommu->dev->dev), iommu->cap_ptr);
> > +		if (iommu->cap & (1 << IOMMU_CAP_EFR)) {
> > +			pr_info("AMD-Vi:  Extended features: ");
> > +			for (i = 0; feat_str[i]; ++i)
> > +				if (iommu_feature(iommu, (1ULL << i)))
> > +					pr_cont(" %s", feat_str[i]);
> 
> I think this should use {} around the for loop
> and this would be better as:
> 
> 	static const char * const feat_str[] = {
> 		"PreF", "PPR", "X2APIC", "NX", "GT", "[5]",
> 		"IA", "GA", "HE", "PC"
> 	};
> []
> 			for (i = 0; ARRAY_SIZE(feat_str); i++) {
> 				if (iommu_feature(iommu, (1ULL << i)))
> 					pr_cont(" %s", feat_str[i]);
>  			}

Changed that, thanks.

> I don't see the utility of the separate function and
> this could just be inlined in the calling function.

Well, the benefit is that the function call can be easily moved to
another place if necessary. So I left the printks in the seperate
function. The compiler will inline them anyway.

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

