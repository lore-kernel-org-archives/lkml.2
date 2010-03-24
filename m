Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab0CXSif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:38:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:35955 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755960Ab0CXSic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:38:32 -0400
Message-ID: <4BAA5BDE.7020207@kernel.org>
Date: Wed, 24 Mar 2010 11:37:18 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jbarnes@virtuousgeek.org, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.cy
References: <alpine.LFD.2.00.1003222233440.3147@localhost.localdomain>	 <4BA7EE72.7000507@kernel.org>	 <alpine.LFD.2.00.1003222329050.3147@localhost.localdomain>	 <4BA80019.5000900@kernel.org>	 <alpine.LFD.2.00.1003230046050.3147@localhost.localdomain>	 <4BA813A4.1010704@kernel.org>	 <alpine.LFD.2.00.1003230213260.3147@localhost.localdomain>	 <4BA8594F.8090205@kernel.org> <20100323080252.GA4848@elte.hu>	 <4BA883C0.2070102@kernel.org>  <20100323094834.GB4576@elte.hu>	 <1269404982.8599.148.camel@pasglop> <1269405882.8599.155.camel@pasglop>	 <4BA9A8F8.5070206@kernel.org> <1269416637.8599.183.camel@pasglop>
In-Reply-To: <1269416637.8599.183.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 12:43 AM, Benjamin Herrenschmidt wrote:
> On Tue, 2010-03-23 at 22:54 -0700, Yinghai Lu wrote:
>> if the array can be doubled and have old one copied to new one. 
>> then we don't change lmb.c too much.
>>
>> new early_res.c exend lmb. and another half already works with x86 to
>> replace bootmem.
>>
>> will check if i can produce one patch to make powerpc to reuse
>> early_res/nobootmem
> 
> While at it, can you rename early_res to something that doesn't
> suck ? :-)
> 
ok, 

please check following renaming is ok to you.

the api from linux/early_res.h

#ifndef _LINUX_EARLY_RES_H
#define _LINUX_EARLY_RES_H
#ifdef __KERNEL__

extern void reserve_early(u64 start, u64 end, char *name);
extern void free_early(u64 start, u64 end);
void lmb_reserved_to_bootmem(u64 start, u64 end);

u64 find_early_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
                         u64 size, u64 align);

void add_lmb_memory(u64 start, u64 end);

u64 find_lmb_area(u64 start, u64 end, u64 size, u64 align);
u64 find_lmb_area_size(u64 start, u64 *sizep, u64 align);
u64 find_lmb_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
void lmb_register_active_regions(int nid, unsigned long start_pfn,
                                         unsigned long last_pfn);
u64 lmb_hole_size(u64 start, u64 end);
u64 get_max_mapped(void);
struct range;
int get_free_all_memory_range(struct range **rangep, int nodeid);

#endif /* __KERNEL__ */

#endif /* _LINUX_EARLY_RES_H */

====>

extern void reserve_lmb(u64 start, u64 end, char *name);
extern void free_lmb(u64 start, u64 end);
void lmb_reserved_to_bootmem(u64 start, u64 end);

u64 __find_lmb_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
                         u64 size, u64 align);

void add_lmb_memory(u64 start, u64 end);

u64 find_lmb_area(u64 start, u64 end, u64 size, u64 align);
u64 find_lmb_area_size(u64 start, u64 *sizep, u64 align);
u64 find_lmb_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
void lmb_register_active_regions(int nid, unsigned long start_pfn,
                                         unsigned long last_pfn);
u64 lmb_hole_size(u64 start, u64 end);
u64 get_max_mapped(void);
struct range;
int get_free_all_memory_range(struct range **rangep, int nodeid);

Thanks

Yinghai
