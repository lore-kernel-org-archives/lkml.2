Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1HNQa5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:30:57 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:34079 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577Ab1HNQF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:05:59 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: FYI GCC 4.6.x miscompiles the kernel
References: <m3y5ywx602.fsf@intrepid.localdomain>
	<201108140327.06726.marek.vasut@gmail.com>
Date: Sun, 14 Aug 2011 18:05:55 +0200
In-Reply-To: <201108140327.06726.marek.vasut@gmail.com> (Marek Vasut's message
	of "Sun, 14 Aug 2011 03:27:05 +0200")
Message-ID: <m31uwo6krg.fsf_-_@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correction: this bug isn't ARM-specific.

Marek Vasut <marek.vasut@gmail.com> writes:

>> Current gcc-4.6.x SVN, ARMEB EABI.
>
> Shouldn't this go to GCC ML too ?

Nope, I put it in bugzilla.

>> unsigned var[2];
>>
>> void test(int arg)
>> {
>>         unsigned v = *(volatile unsigned *)(&var[arg]);
>>         *(volatile unsigned *)(&var[arg]) = v;
>> }
>>
>> Disassembly of section .text:
>>
>> 00000000 <test>:
>>    0:   e12fff1e        bx      lr

On x86-64:
0000000000000000 <test>:
   0:   f3 c3                   repz retq
-- 
Krzysztof Halasa
