Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab0ENGY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 02:24:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18186 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab0ENGYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 02:24:24 -0400
Message-ID: <4BECEBF4.7000402@oracle.com>
Date: Thu, 13 May 2010 23:21:40 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 03/35] lmb: Add ARCH_DISCARD_LMB to put lmb code to .init
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>	 <1273796396-29649-4-git-send-email-yinghai@kernel.org> <1273803249.21352.357.camel@pasglop>
In-Reply-To: <1273803249.21352.357.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4BECEC81.00FB:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 07:14 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:
>> So those lmb bits could be released after kernel is booted up.
>>
>> Arch code could define ARCH_DISCARD_LMB in asm/lmb.h,
>> __init_lmb will become __init, __initdata_lmb will becom __initdata
>>
>> x86 code will use that.
> 
> So you do not intend to use lmb after boot ? This will break the debugfs
> files unless you also remove those.

no, x86 don't lmb after boot.

yes


...

>> @@ -695,7 +695,7 @@ static int __init early_lmb(char *p)
>>  }
>>  early_param("lmb", early_lmb);
>>  
>> -#ifdef CONFIG_DEBUG_FS
>> +#if defined(CONFIG_DEBUG_FS) && !defined(ARCH_DISCARD_LMB)
>>  
>>  static int lmb_debug_show(struct seq_file *m, void *private)
>>  {
> 

it will check ARCH_DISCARD_LMB
