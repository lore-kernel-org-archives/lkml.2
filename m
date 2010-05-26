Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab0EZNph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:45:37 -0400
Received: from king.tilera.com ([72.1.168.226]:10445 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab0EZNpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:45:34 -0400
Message-ID: <4BFD25DE.7030705@tilera.com>
Date: Wed, 26 May 2010 09:45:02 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: liqin.chen@sunplusct.com, Arnd Bergmann <arnd@arndb.de>,
       linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <OF1161BF2B.C681A3D5-ON4825772F.000A9BAB-4825772F.000F0B04@sunplusct.com>
In-Reply-To: <OF1161BF2B.C681A3D5-ON4825772F.000A9BAB-4825772F.000F0B04@sunplusct.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2010 13:45:32.0616 (UTC) FILETIME=[B6112480:01CAFCD9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/2010 10:44 PM, liqin.chen@sunplusct.com wrote:
> Arnd Bergmann <arnd@arndb.de>  at 2010-05-25 23:03:11
>>> - You renamed __NR__llseek to __NR_llseek, which of course seems pretty
>>>       
>>> reasonable, but libc expects to see the former (both glibc and uclibc). 
>>>       
>>> Is it worth requiring non-standard libc code?  I may just add
>>> __NR__llseek as an alias in my unistd.h for now.
>>>       
>> That was probably just a mistake on my side. The only other
>> architecture using the generic version so far is score, so
>> maybe Chen Liqin can comment on how he dealt with this and
>> if he depends on the definition now.
>>     
> When we port glibc to score arch, we fixed the llseek.c file,
> remove the underscore before llseek. maybe it has compatible problems, 
> but it work ok with score application.
>   

This sounds like the right solution for the generic code too, but
presumably it would need some kind of "#if !defined(__NR_llseek) &&
defined(__NR__llseek)" hackery in the llseek.c common code in glibc.
Ulrich, does that seem like the right direction for you?

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


