Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1B1SUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:20:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:46626 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab1B1SUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:20:12 -0500
Message-ID: <4D6BE756.1090800@infradead.org>
Date: Mon, 28 Feb 2011 15:20:06 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: Re: [PATCH v2 -resend#1 1/1] V4L: videobuf, don't use dma addr as
 physical
References: <1298885822-10083-1-git-send-email-jslaby@suse.cz> <20110228145301.GC10846@dumpdata.com> <4D6BC3AE.903@suse.cz>
In-Reply-To: <4D6BC3AE.903@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-02-2011 12:47, Jiri Slaby escreveu:
> On 02/28/2011 03:53 PM, Konrad Rzeszutek Wilk wrote:
>> On Mon, Feb 28, 2011 at 10:37:02AM +0100, Jiri Slaby wrote:
>>> mem->dma_handle is a dma address obtained by dma_alloc_coherent which
>>> needn't be a physical address in presence of IOMMU. So ensure we are
>>
>> Can you add a comment why you are fixing it? Is there a bug report for this?
>> Under what conditions did you expose this fault?
> 
> No, by a just peer review when I was looking for something completely
> different.
> 
>> You also might want to mention that "needn't be a physical address as
>> a hardware IOMMU can (and most likely) will return a bus address where
>> physical != bus address."
> 
> Mauro, do you want me to resend this with such an udpate in the changelog?

Having it properly documented is always a good idea, especially since a similar
fix might be needed on other drivers that also need contiguous memory. While it
currently is used only on devices embedded on hardware with no iommu, there are
some x86 hardware that doesn't allow DMA scatter/gather.

Btw, it may be worth to take a look at vb2 dma contig module, as it might have
similar issues.

>> Otherwise you can stick 'Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>'
>> on it.

Cheers,
Mauro
