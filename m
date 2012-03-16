Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032558Ab2CPBG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 21:06:29 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:36517 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965275Ab2CPBG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 21:06:27 -0400
Message-ID: <4F6291C6.4040903@snapgear.com>
Date: Fri, 16 Mar 2012 11:05:10 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: <paul.gortmaker@windriver.com>, <hpa@zytor.com>,
        <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <arnd@arndb.de>,
        <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 13/35] Disintegrate asm/system.h for M68K [ver #2]
References: <4F608A15.9030609@snapgear.com> <20120312233602.13888.27659.stgit@warthog.procyon.org.uk> <20120312233816.13888.142.stgit@warthog.procyon.org.uk> <7100.1331842713@redhat.com>
In-Reply-To: <7100.1331842713@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi David,

On 16/03/12 06:18, David Howells wrote:
> Greg Ungerer<gerg@snapgear.com>  wrote:
>> This breaks compilation for m68k targets with:
>>
>>    CC      net/ipv4/ip_input.o
>> In file included from
>> /home/gerg/new-wave.320/linux-3.x/arch/m68k/include/asm/system.h:3:0,
>>                   from net/ipv4/ip_input.c:116:
>> /home/gerg/new-wave.320/linux-3.x/arch/m68k/include/asm/cmpxchg.h: In function
>> æ__xchgÆ:
>> /home/gerg/new-wave.320/linux-3.x/arch/m68k/include/asm/cmpxchg.h:33:3: error:
>> implicit declaration of function æBUGÆ
>>
>> The old system.h included linux/kernel.h which includes asm/bug.h.
>> Just including asm/bug.h here in cmpxchg.h is not enough to fix it.
>> If you include linux/kernel.h though it compiles cleanly.
>
> Which targets, btw?

Looks to be all the non-MMU ones.

So that is the following defconfigs: m5208evb, m5249evb m5272c3,
m5275evb, m5307c3 and m5407c3. For example this configure line:

     make ARCH=m68k CROSS_COMPILE=m68k-uclinux- m5208evb_defconfig

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
