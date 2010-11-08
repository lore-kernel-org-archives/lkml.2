Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab0KHLsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:48:09 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:60643 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab0KHLsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:48:08 -0500
X-Loopcount0: from 10.152.240.141
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Paul Koning <paul_koning@dell.com>
In-Reply-To: <AANLkTi=tC01jshWAr_HyVs6-HKK-Puarb6cLpxZyg-Kr@mail.gmail.com>
Date: Mon, 8 Nov 2010 06:47:59 -0500
Cc: Andi Kleen <andi@firstfloor.org>, Andreas Schwab <schwab@linux-m68k.org>,
        Jim <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Content-Transfer-Encoding: 8BIT
Message-Id: <E1D1023D-4F2D-4EF4-8E97-CC5685B57A19@dell.com>
References: <4CD538CA.8010901@xs4all.nl>	<87wroostw3.fsf@basil.nowhere.org>	<m2hbfsu57i.fsf@igel.home>	<87k4kospnd.fsf@basil.nowhere.org>	<AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>	<877hgorrj1.fsf@basil.nowhere.org> <AANLkTi=tC01jshWAr_HyVs6-HKK-Puarb6cLpxZyg-Kr@mail.gmail.com>
To: Richard Guenther <richard.guenther@gmail.com>
X-Mailer: Apple Mail (2.1081)
X-OriginalArrivalTime: 08 Nov 2010 11:48:00.0695 (UTC) FILETIME=[CB5DE470:01CB7F3A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 8, 2010, at 6:20 AM, Richard Guenther wrote:

> On Mon, Nov 8, 2010 at 12:20 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> Richard Guenther <richard.guenther@gmail.com> writes:
>> 
>>> On Mon, Nov 8, 2010 at 12:03 AM, Andi Kleen <andi@firstfloor.org> wrote:
>>>> Andreas Schwab <schwab@linux-m68k.org> writes:
>>>>> 
>>>>> The asm fails to mention that it modifies *regs.
>>>> 
>>>> It has a memory clobber, that should be enough, no?
>>> 
>>> No.  A memory clobber does not cover automatic storage.
>> 
>> That's a separate problem.
>> 
>>> Btw, I can't see a testcase anywhere so I just assume Andreas got
>>> it right as usual.
>> 
>> An asm with live inputs and outputs should never be optimized
>> way. If 4.5.1 started doing that it's seriously broken.
> 
> Please provide a testcase, such asms can be optimized if the
> outputs are dead.

I don't know about 4.5, but I noticed that with 4.6 (trunk), testcasese like gcc.c-torture/compile/20000804-1.c optimize away the asm and all the operand generation except for -O0.

	paul

