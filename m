Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab1BTERO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 23:17:14 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41548 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab1BTERN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 23:17:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XVXIn2wa70F+RHUrsp8WUtR1Z3gROpRF0VbVdz0A4VmuN8oPGaeDVObGzkXXZWLtMP
         tZ+GT5JqGAiDxGiYVazbhi5PGJFsUa7MMSKTJYuNSHebHN8e1+L06cU6cH4Jow8iGDBN
         xZrwYvqcMimHQzksgZZMXySud/3DyEV0l4M4w=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1102191944530.32280@chino.kir.corp.google.com>
References: <4D5EC05A.60103@kernel.org>
	<4D5EC184.6000505@kernel.org>
	<alpine.DEB.2.00.1102191944530.32280@chino.kir.corp.google.com>
Date: Sat, 19 Feb 2011 20:17:11 -0800
X-Google-Sender-Auth: 33JUvefcsx5cczm6rKohtUptFjA
Message-ID: <AANLkTikgR8vEhz3Hsmx96QqZw_gsLZetc3W_9evf3ufb@mail.gmail.com>
Subject: Re: [PATCH 2/4] x86, numa: Do not adjust start/end for early_node_mem()
From: Yinghai Lu <yinghai@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 8:03 PM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 18 Feb 2011, Yinghai Lu wrote:
>
>> Index: linux-2.6/arch/x86/mm/numa_64.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/mm/numa_64.c
>> +++ linux-2.6/arch/x86/mm/numa_64.c
>> @@ -164,14 +164,9 @@ static void * __init early_node_mem(int
>>       unsigned long mem;
>>
>>       /*
>> -      * put it on high as possible
>> -      * something will go with NODE_DATA
>> +      * memblock find will follow top-down, so don't need to adjust
>> +      *   start anymore
>>        */
>> -     if (start < (MAX_DMA_PFN<<PAGE_SHIFT))
>> -             start = MAX_DMA_PFN<<PAGE_SHIFT;
>> -     if (start < (MAX_DMA32_PFN<<PAGE_SHIFT) &&
>> -         end > (MAX_DMA32_PFN<<PAGE_SHIFT))
>> -             start = MAX_DMA32_PFN<<PAGE_SHIFT;
>>       mem = memblock_x86_find_in_range_node(nodeid, start, end, size, align);
>>       if (mem != MEMBLOCK_ERROR)
>>               return __va(mem);
>>
>
> The old code guarantees that the range is from a single zone, and even
> though memblock may be top -> down, it seems like there would be
> configurations where this would still be an issue (perhaps simulating it
> with numa=fake for testing?) if it crosses the boundary.

memblock_x86_find_in_range_node() will go over with early_node_map[].
so it will always can get right on node allocation.

Thanks

Yinghai
