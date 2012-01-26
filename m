Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2AZS1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:27:09 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:47957
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601Ab2AZS1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:27:07 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F219AF2.6070108@freescale.com>
Date: Thu, 26 Jan 2012 12:26:58 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Stuart Yoder <b08248@gmail.com>, Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com> <201201191646.13798.laurent.pinchart@ideasonboard.com> <20120119160739.GB2205@amd.com> <201201191727.10176.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201191727.10176.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 10:27 AM, Laurent Pinchart wrote:
> Hi Joerg,
> 
> On Thursday 19 January 2012 17:07:39 Joerg Roedel wrote:
>> On Thu, Jan 19, 2012 at 04:46:13PM +0100, Laurent Pinchart wrote:
>>>> +struct iommu_domain_geometry {
>>>> +	u64 aperture_start;	/* First address that can be mapped    */
>>>> +	u64 aperture_end;	/* Last address that can be mapped     */
>>>
>>> Would it make sense to use a platform-dependent type that represents
>>> physical addresses instead of u64 ?
>>
>> Well, u64 is a catch-all datatype which should suit all drivers. Is this
>> a problem at ARM?
> 
> No, it's not a problem for ARM, at least to my knowledge. It just struck me as 
> weird, as we have specific data types for other kinds of addresses (such as 
> dma_addr_t).

If we want to be able to expose these attribute structs to userspace via
vfio, we'll want to stick with fixed size types.

-Scott

