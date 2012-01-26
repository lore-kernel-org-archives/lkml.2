Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab2AZSmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:42:22 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:11007 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2AZSmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:42:20 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F219E82.106@freescale.com>
Date: Thu, 26 Jan 2012 12:42:10 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Sethi Varun-B16395 <B16395@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com> <1326983405-319-3-git-send-email-joerg.roedel@amd.com> <C5ECD7A89D1DC44195F34B25E172658D038749@039-SN2MPN1-011.039d.mgd.msft.net> <20120120160344.GG2205@amd.com> <4F219A9C.8000400@freescale.com> <20120126183116.GI19255@amd.com>
In-Reply-To: <20120126183116.GI19255@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 12:31 PM, Joerg Roedel wrote:
> On Thu, Jan 26, 2012 at 12:25:32PM -0600, Scott Wood wrote:
>> How should a PAMU driver interpret "force_aperture"?  When would DMA
>> ever be allowed outside the specified range?  What does the range mean
>> in that case?
> 
> The force_aperture flag indicated whether DMA is only allowed between
> aperture_start and apertuer_end or if DMA is allowed outside of this
> range too (unmapped in this case).
> 
> The AMD GART for example would set this flag to false because it does
> not enforce DMA to be in the aperture-range.

Why is this not an AMD GART specific attribute?  Is there any feature
reporting mechanism by which a user would know if that flag is supported?

If it must be in the generic struct, it would be nice to invert the
polarity so that the default (after zeroing) is something that should be
more widely supportable, and less likely to create unintended identity
mappings.

How in general are available attributes and restrictions on possible
values to be communicated to users of the API?

-Scott

