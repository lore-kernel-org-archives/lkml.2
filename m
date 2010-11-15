Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab0KOSns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:43:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904Ab0KOSnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:43:47 -0500
Message-ID: <4CE17F17.1010201@redhat.com>
Date: Mon, 15 Nov 2010 11:42:31 -0700
From: Jeff Law <law@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: Andi Kleen <andi@firstfloor.org>, Jim <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling  drivers/char/i8k.c
 ?
References: <4CD538CA.8010901@xs4all.nl> <87wroostw3.fsf@basil.nowhere.org> <m2hbfsu57i.fsf@igel.home>
In-Reply-To: <m2hbfsu57i.fsf@igel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/10 15:41, Andreas Schwab wrote:
> Andi Kleen<andi@firstfloor.org>  writes:
>
>> Jim<jim876@xs4all.nl>  writes:
>>
>>> After upgrading my Dell laptop, both OS+kernel the i8k interface was giving
>>> nonsensical output. As it turned out it's not the kernel but compiler
>>> upgrade which broke this.
>>>
>>> Guys at Archlinux have found the underlying cause (but don't seem to have
>>> submitted a patch yet):
>>>    https://bbs.archlinux.org/viewtopic.php?pid=780692#p780692
>>> gcc seems to optimize the assembly statements away.
>>>
>>> And indeed, applying this patch makes the i8k interface work again,
>>> i.e. replacing the asm(..) construct by  asm volatile(..)
>> The compiler really should not optimize the asm away, because
>> it has both input and output arguments which are later used.
>> "asm volatile" normally just means "don't move significantly"
> The asm fails to mention that it modifies *regs.
But there's a memory clobber, that should be sufficient to indicate 
*regs is modified.

jeff

