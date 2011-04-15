Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1DOCYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 22:24:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50151 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab1DOCYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 22:24:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZcsNqr0gJ//E1yOjya1VwmDARjyBOIj142fsjAAlzjfF88ViEdAN9ahFyth+KDaWry
         H2h47BpMwG6dJzyhFZHcm7QAVPjgzLT5yokhyOX5/SBJ0l2mSXoATHEa4JNnPPBhoXiD
         hiyEAbCzVWCgyGLHxnNzpCjdiDnJTfwyJ75HM=
MIME-Version: 1.0
In-Reply-To: <20110414223036.GA7335@n2100.arm.linux.org.uk>
References: <1302817968-28516-1-git-send-email-fernando.lugo@ti.com>
	<20110414223036.GA7335@n2100.arm.linux.org.uk>
Date: Fri, 15 Apr 2011 11:24:16 +0900
X-Google-Sender-Auth: Yr8VCMyoeuIVfs6H29sFOo_SqdE
Message-ID: <BANLkTikfXbtsqaw5ZuP_BbDCtsxXOHZs_w@mail.gmail.com>
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2 cache
From: KyongHo Cho <pullip.cho@samsung.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, Ramesh Gupta <grgupta@ti.com>,
        Hari Kanigeri <h-kanigeri2@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Russell.

I think we need cache maintenance operations that effect on inner and
outer caches at the same time.

Even though the DMA APIs are not for cache maintenance but for IO mapping,
they are useful for cache maint'
because they operate on inner and outer caches.

As you know, inner cache of Cortex-A is logical cache and outer cache
is physical cache in the programmer's point of view.
We need logical address and physical address at the same time to clean
or invalidate inner and outer cache.
That means we need to translate logical to physical address and it is
sometimes not trivial.

Finally, the kernel will contain many similar routines that do same thing.

On Fri, Apr 15, 2011 at 7:30 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Apr 14, 2011 at 04:52:48PM -0500, Fernando Guzman Lugo wrote:
>> From: Ramesh Gupta <grgupta@ti.com>
>>
>> This patch is to flush the iommu page table entries from L1 and L2
>> caches using dma_map_single. This also simplifies the implementation
>> by removing the functions  flush_iopgd_range/flush_iopte_range.
>
> No.  This usage is just wrong.  If you're going to use the DMA API then
> unmap it, otherwise the DMA API debugging will go awol.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
