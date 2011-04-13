Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245Ab1DMWBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 18:01:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52187 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab1DMWBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 18:01:10 -0400
Message-ID: <4DA61CCF.2080805@kernel.org>
Date: Wed, 13 Apr 2011 14:59:43 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Ingo Molnar <mingo@elte.hu>, Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org> <20110413193459.GL19819@8bytes.org> <4DA60C30.4060606@kernel.org> <20110413215025.GA18463@8bytes.org>
In-Reply-To: <20110413215025.GA18463@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DA61D0F.002B,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 02:50 PM, Joerg Roedel wrote:
> On Wed, Apr 13, 2011 at 01:48:48PM -0700, Yinghai Lu wrote:
>> -	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<20);
>> +	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<21);
> 
> Btw, while looking at this code I wondered why the 512M goal is enforced
> by the alignment. Start could be set to 512M instead and the alignment
> can be aper_size as it should. Any reason for such a big alignment?
> 

when using bootmem, try to use big alignment (512M ), so we could avoid take ram range below 512M.

commit 7677b2ef6c0c4fddc84f6473f3863f40eb71821b
Author: Yinghai Lu <yhlu.kernel.send@gmail.com>
Date:   Mon Apr 14 20:40:37 2008 -0700

    x86_64: allocate gart aperture from 512M
    
    because we try to reserve dma32 early, so we have chance to get aperture
    from 64M.
    
    with some sequence aperture allocated from RAM, could become E820_RESERVED.
    
    and then if doing a kexec with a big kernel that uncompressed size is above
    64M we could have a range conflict with still using gart.
    
    So allocate gart aperture from 512M instead.
    
    Also change the fallback_aper_order to 5, because we don't have chance to get
    2G or 4G aperture.

We can change it back to 32M or make it equal to size.

> 
> P.S.: The box is still in the office, I will try this debug-patch
>       tomorrow.

Alexandre's system is working at 0xa4000000 with 2.6.38.2

So it is not low address problem. could be other reason like
some other code could need lower address.

Thanks

Yinghai
