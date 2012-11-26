Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2KZNoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:44:09 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45038 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2KZNoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:44:06 -0500
Message-id: <50B37222.7010709@samsung.com>
Date: Mon, 26 Nov 2012 14:44:02 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
References: <20121126133153.50c5fa21cacd2858f30509e3@canb.auug.org.au>
In-reply-to: <20121126133153.50c5fa21cacd2858f30509e3@canb.auug.org.au>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 11/26/2012 3:31 AM, Stephen Rothwell wrote:
> Hi Mauro,
>
> After merging the v4l-dvb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> ERROR: "dma_common_get_sgtable" [drivers/media/v4l2-core/videobuf2-dma-contig.ko] undefined!
>
> Caused by commit 9ef2cbeb8192 ("[media] v4l: vb2-dma-contig: add support
> for DMABUF exporting").  dma_common_get_sgtable() is called from the
> inline dma_get_sgtable_attrs() and dma_get_sgtable_attrs() is "called
> from" dma_get_sgtable().  dma_common_get_sgtable() is only defined if
> ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY is set which depends on
> CONFIG_HAVE_GENERIC_DMA_COHERENT being set which it isn't for this build.
>
> I have used the v4l-dvb tree form next-20121026 for today.
>
> Please try testing your tree with an x86_64 allmodconfig build.

Thanks for spotting this issue. It's my fault, code for 
dma_common_get_sgtable()
function was incorrectly placed under ifdefs in drivrs/base/dma-mapping.

I've posted a fix, please refer to the "dma-mapping: fix 
dma_common_get_sgtable()
conditional compilation" patch, which I will push to Linus asap.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


