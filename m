Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933896Ab0KOW7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:59:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933831Ab0KOW7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:59:51 -0500
Message-ID: <4CE1BB10.5090501@redhat.com>
Date: Mon, 15 Nov 2010 15:58:24 -0700
From: Jeff Law <law@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Richard Guenther <richard.guenther@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, Andreas Schwab <schwab@linux-m68k.org>,
        Jim <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
References: <4CD538CA.8010901@xs4all.nl>	<87wroostw3.fsf@basil.nowhere.org>	<m2hbfsu57i.fsf@igel.home>	<87k4kospnd.fsf@basil.nowhere.org>	<AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>	<4CE17FB6.7000800@redhat.com> <AANLkTim-2XE=4MbfDLXkg+jj=P5wj2cVKBHemRHLZn2L@mail.gmail.com>
In-Reply-To: <AANLkTim-2XE=4MbfDLXkg+jj=P5wj2cVKBHemRHLZn2L@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/10 15:07, Richard Guenther wrote:
> On Mon, Nov 15, 2010 at 7:45 PM, Jeff Law<law@redhat.com>  wrote:
>> On 11/08/10 03:49, Richard Guenther wrote:
>>> On Mon, Nov 8, 2010 at 12:03 AM, Andi Kleen<andi@firstfloor.org>    wrote:
>>>> Andreas Schwab<schwab@linux-m68k.org>    writes:
>>>>> The asm fails to mention that it modifies *regs.
>>>> It has a memory clobber, that should be enough, no?
>>> No.  A memory clobber does not cover automatic storage.
>> A memory clobber should clobber anything in memory, including autos in
>> memory; if it doesn't, then that seems like a major problem.  I'd like to
>> see the rationale behind not clobbering autos in memory.
> Non-address taken automatic storage.  (note that we don't excercise this
> in optimization yet)
If the address of the auto isn't taken, then why is the object in memory 
to begin with (with the obvious exception for aggregates).

Jeff
