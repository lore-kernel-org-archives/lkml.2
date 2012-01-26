Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab2AZTAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 14:00:45 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:59970 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2AZTAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 14:00:44 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F21A2D5.6000204@freescale.com>
Date: Thu, 26 Jan 2012 13:00:37 -0600
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
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com> <1326983405-319-3-git-send-email-joerg.roedel@amd.com> <C5ECD7A89D1DC44195F34B25E172658D038749@039-SN2MPN1-011.039d.mgd.msft.net> <20120120160344.GG2205@amd.com> <4F219A9C.8000400@freescale.com> <20120126183116.GI19255@amd.com> <4F219E82.106@freescale.com> <20120126185101.GJ19255@amd.com>
In-Reply-To: <20120126185101.GJ19255@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 12:51 PM, Joerg Roedel wrote:
> On Thu, Jan 26, 2012 at 12:42:10PM -0600, Scott Wood wrote:
>> On 01/26/2012 12:31 PM, Joerg Roedel wrote:
>>> The force_aperture flag indicated whether DMA is only allowed between
>>> aperture_start and apertuer_end or if DMA is allowed outside of this
>>> range too (unmapped in this case).
>>>
>>> The AMD GART for example would set this flag to false because it does
>>> not enforce DMA to be in the aperture-range.
>>
>> Why is this not an AMD GART specific attribute?  Is there any feature
>> reporting mechanism by which a user would know if that flag is supported?
> 
> Because this is a flag that makes sense for all IOMMU. Every IOMMU
> either allows DMA outside its aperture or it doesn't.
> 
> Another reason why it must be in the generic struct is the intended
> generic dma-ops layer on-top. This code can decide on this flag wheter a
> address needs to be remapped at all.

So the DMA API would just read this, not write it?

Still no reason why it couldn't be a separate attribute.  Then if you
get a failure trying to write it, it's more obvious why.

>> If it must be in the generic struct, it would be nice to invert the
>> polarity so that the default (after zeroing) is something that should be
>> more widely supportable, and less likely to create unintended identity
>> mappings.
> 
> Setting this flag wrong does not create unintended identity mappings.

Failing to set it means that DMA can go through that is not limited to
explicitly created mappings.  In some contexts (e.g. vfio) this is a
security hole.

>> How in general are available attributes and restrictions on possible
>> values to be communicated to users of the API?
> 
> The possible attributes can be found in inlude/linux/iommu.h.

I meant possible for the currently running hardware.

> But I don't understand what you mean by 'restrictions on possible values'. The
> geometry attribute is filled by the IOMMU driver dependent on the
> hardware capabilities. There are no limits from the iommu-code side.

How does the user of the iommu API discover the hardware capabilities?

-Scott

