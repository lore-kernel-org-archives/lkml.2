Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab2DYOP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:15:56 -0400
Received: from smtp-out-106.synserver.de ([212.40.185.106]:1049 "EHLO
	smtp-out-098.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758730Ab2DYOPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:15:55 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29853
Message-ID: <4F9807AF.3000804@metafoo.de>
Date: Wed, 25 Apr 2012 16:18:23 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dmaengine: care sd_dma_address/len in dmaengine_prep_slave_single()
References: <8739axwnh9.wl%kuninori.morimoto.gx@renesas.com> <1327917366.1527.42.camel@vkoul-udesk3> <87pqe04qtk.wl%kuninori.morimoto.gx@renesas.com> <20120201182201.GE889@n2100.arm.linux.org.uk>
In-Reply-To: <20120201182201.GE889@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 07:22 PM, Russell King - ARM Linux wrote:
> On Mon, Jan 30, 2012 at 05:13:30PM -0800, Kuninori Morimoto wrote:
>> +	sg_init_table(&sg, 1);
>> +	sg_set_page(&sg, pfn_to_page(PFN_DOWN(buf)),
>> +		    len, offset_in_page(buf));
> 
> There's not much point setting this - the page/virtual address should
> not be used by DMA engines as that may not reflect what's being requested
> (especially if there's an IOMMU in the way.)

I was just looking at this again and there are actually quite a few dma
engine drivers which use sg->length and sg_phys(sg). I guess these would
break if the sg_set_page was to be removed. Should these drivers be changed
to use sg_dma_len and sg_dma_address?

Thanks
- Lars
