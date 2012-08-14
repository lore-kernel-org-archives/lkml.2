Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab2HNQ0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 12:26:49 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:26120
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752652Ab2HNQ0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 12:26:44 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.133;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0710HT004.namprd07.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: PS-4(zzbb2dI98dI9371I1432Izz1202hzz8275bhz2dh2a8h668h839hd25he5bhf0ah107ah)
Message-ID: <502A7C3C.6080907@caviumnetworks.com>
Date: Tue, 14 Aug 2012 09:26:36 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Huacai Chen <chenhuacai@gmail.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>
Subject: Re: [PATCH V5 09/18] MIPS: Loongson: Add swiotlb to support big memory
 (>4GB).
References: <1344677543-22591-1-git-send-email-chenhc@lemote.com>	<1344677543-22591-10-git-send-email-chenhc@lemote.com>	<20120813175447.GB26088@phenom.dumpdata.com> <CAAhV-H7mJUC9njF_wHda8ymUBkUom5AZ+u8OFXtA42uyA-hFxg@mail.gmail.com>
In-Reply-To: <CAAhV-H7mJUC9njF_wHda8ymUBkUom5AZ+u8OFXtA42uyA-hFxg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 10:57 PM, Huacai Chen wrote:
> Hi, David,
>
> Seems like you are the original author of code in
> arch/mips/cavium-octeon/dma-octeon.c. Could you please tell me why we
> need mb() in alloc_coherent(), map_page(), map_sg()? It seems like
> because of cache coherency (CPU write some data, then map the page for
> a device, if without mb(), then device may read wrong data.) but I'm
> not sure.
>

That is essentially correct.

The DMA API requires certain memory barrier semantics.  These are 
achieved with the mb() in the OCTEON code.

> On Tue, Aug 14, 2012 at 1:54 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com>  wrote:
>>> +static void *loongson_dma_alloc_coherent(struct device *dev, size_t size,
>>> +                             dma_addr_t *dma_handle, gfp_t gfp, struct dma_attrs *attrs)

I know nothing about Loongson, so I cannot comment on what is required 
for it.

David Daney

