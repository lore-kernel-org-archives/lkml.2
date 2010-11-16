Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341Ab0KPELa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 23:11:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520Ab0KPEL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 23:11:29 -0500
Message-ID: <4CE20449.4050403@redhat.com>
Date: Mon, 15 Nov 2010 21:10:49 -0700
From: Jeff Law <law@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Richard Guenther <richard.guenther@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, Andreas Schwab <schwab@linux-m68k.org>,
        Jim <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
References: <4CD538CA.8010901@xs4all.nl>	<87wroostw3.fsf@basil.nowhere.org>	<m2hbfsu57i.fsf@igel.home>	<87k4kospnd.fsf@basil.nowhere.org>	<AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>	<4CE17FB6.7000800@redhat.com>	<AANLkTim-2XE=4MbfDLXkg+jj=P5wj2cVKBHemRHLZn2L@mail.gmail.com>	<4CE1BB10.5090501@redhat.com> <AANLkTi=piiT5MCWYvw+4wQPx=e8uVrQmY0Lw+=mnabK_@mail.gmail.com>
In-Reply-To: <AANLkTi=piiT5MCWYvw+4wQPx=e8uVrQmY0Lw+=mnabK_@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/10 16:07, Richard Guenther wrote:
>>
>> If the address of the auto isn't taken, then why is the object in memory to
>> begin with (with the obvious exception for aggregates).
> Exactly sort of my point.  If people pass the address of&x to an asm
> and modify&x + 8 expecting the "adjacent" stack location to be changed
> I want to tell them that's not a supported way to get to another stack
> variable (even if they clobber "memory").  Or consider the C-decl guy
> who wants to access adjacent parameters by address arithmetic on
> the address of the first param ...
Well, in that case, I think we can easily say that the programmer has 
gone off the deep end and has entered the realm of undefined behavior.

Presumably we rooted out all relevant instances of the latter over the 
last 20 years...  It was fairly common in the past, but I doubt anyone 
worth caring about is still writing code assuming they can take the 
address of parameter A, offset it and get parameters B, C, D, etc.

jeff
