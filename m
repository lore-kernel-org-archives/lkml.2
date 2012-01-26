Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab2AZSZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:25:44 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:16090
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660Ab2AZSZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:25:43 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F219A9C.8000400@freescale.com>
Date: Thu, 26 Jan 2012 12:25:32 -0600
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
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com> <1326983405-319-3-git-send-email-joerg.roedel@amd.com> <C5ECD7A89D1DC44195F34B25E172658D038749@039-SN2MPN1-011.039d.mgd.msft.net> <20120120160344.GG2205@amd.com>
In-Reply-To: <20120120160344.GG2205@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2012 10:03 AM, Joerg Roedel wrote:
> On Thu, Jan 19, 2012 at 05:16:48PM +0000, Sethi Varun-B16395 wrote:
>>>  struct iommu_domain {
>>>  	struct iommu_ops *ops;
>>>  	void *priv;
>>>  	iommu_fault_handler_t handler;
>>> +	struct iommu_domain_geometry geometry;
>>>  };
>> In case of our iommu implementation the iommu_domain_geometry would
>> include additional attributes. Why can't we let the geometry be
>> Implementation dependent?
> 
> Because the values in this generic geometry-struct make sense for more
> than one IOMMU (short-term for Tegra GART and Freescale PAMU). If you
> have additional vendor-specific ones you could add them via a
> vendor-specific attribute.

Freescale PAMU is the IOMMU that Varun is talking about, that needs
additional geometry attributes (in particular, subwindow count).

How should a PAMU driver interpret "force_aperture"?  When would DMA
ever be allowed outside the specified range?  What does the range mean
in that case?

-Scott

