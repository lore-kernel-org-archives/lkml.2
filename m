Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab0KGWll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 17:41:41 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:43397 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab0KGWlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 17:41:39 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jim <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling  drivers/char/i8k.c ?
References: <4CD538CA.8010901@xs4all.nl> <87wroostw3.fsf@basil.nowhere.org>
X-Yow: Yow!  Are we wet yet?
Date: Sun, 07 Nov 2010 23:41:37 +0100
In-Reply-To: <87wroostw3.fsf@basil.nowhere.org> (Andi Kleen's message of "Sun,
	07 Nov 2010 22:31:24 +0100")
Message-ID: <m2hbfsu57i.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Jim <jim876@xs4all.nl> writes:
>
>> After upgrading my Dell laptop, both OS+kernel the i8k interface was giving
>> nonsensical output. As it turned out it's not the kernel but compiler
>> upgrade which broke this.
>>
>> Guys at Archlinux have found the underlying cause (but don't seem to have
>> submitted a patch yet):
>>   https://bbs.archlinux.org/viewtopic.php?pid=780692#p780692
>> gcc seems to optimize the assembly statements away.
>>
>> And indeed, applying this patch makes the i8k interface work again,
>> i.e. replacing the asm(..) construct by  asm volatile(..)
>
> The compiler really should not optimize the asm away, because
> it has both input and output arguments which are later used.
> "asm volatile" normally just means "don't move significantly"

The asm fails to mention that it modifies *regs.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
