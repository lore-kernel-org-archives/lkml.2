Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1KAROx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 13:14:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52062 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab1KAROw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 13:14:52 -0400
MIME-Version: 1.0
In-Reply-To: <1320155074.2996.190.camel@otta>
References: <CAJw04pD24W_nGSLheWunCa_o7QqBmRf_TSAD44EkzazigRe_nQ@mail.gmail.com>
	<12144.1320040276@neuling.org>
	<CAJw04pAh5QDQMkUHbj9=rRPiUCZejimHiydCJFMAoZeSd_ydhA@mail.gmail.com>
	<20440.1320054588@neuling.org>
	<1320060214.30202.34.camel@pasglop>
	<CAJw04pBpXsTS4=FeG5ZF3nqORXhiOZ=3V60cFCuJfgTiJcCh2g@mail.gmail.com>
	<1320155074.2996.190.camel@otta>
Date: Tue, 1 Nov 2011 22:44:51 +0530
Message-ID: <CAJw04pA3mDOgHrOvPxeXR8Fw6Jn1kBz9qSrgq2vJ7HPpyQwSbg@mail.gmail.com>
Subject: Re: powerpc 476, Little-endian, pte fault
From: Santosh Kumar <santoshkumar.a@gmail.com>
To: Peter Bergner <bergner@vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
        Michael Neuling <mikey@neuling.org>, Ian Munsie <ianmunsi@au1.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The relevant options are -mcpu=476 (no FP unit) and -mcpu=476fp> (with FP unit).  Basically, -mcpu=476 is equivalent to> -mcpu=476fp -msoft-float.
Yes what you have mentioned is right.

I had a problem configuring the GCC for 476 in little endian mode,
therefore I am using 440 compiler. As this compiler doesn't accept
-mcpu=476 i am using -mcpu=440.

So is this PTE fault related to the compiler options?

Thanks,
Santosh Kumar .A

On 1 November 2011 19:14, Peter Bergner <bergner@vnet.ibm.com> wrote:
> On Tue, 2011-11-01 at 08:32 +0530, Santosh Kumar wrote:
>> I am using the same compiler as 476 & 440 instruction is almost the same.
>
> Well the 476 implements ISA 2.05, which I think has added a fair amount
> over the 440.  Not to mention the 476 core that has been released has
> a FP unit.  I'll note that GCC has support for a 476 with and without
> a FP unit, even though AFAIK, we only ship one with a FP unit.
> The relevant options are -mcpu=476 (no FP unit) and -mcpu=476fp
> (with FP unit).  Basically, -mcpu=476 is equivalent to
> -mcpu=476fp -msoft-float.
>
>
>
>> @@ -53,7 +58,12 @@
>>         mullw   r10,r0,r4       # and get the remainder
>>         add     r8,r8,r0
>>         subf    r6,r10,r6
>> +#ifdef CONFIG_INVADER
>>  4:     stw     r7,0(r3)        # return the quotient in *r3
>>         stw     r8,4(r3)
>> +#else
>> +4:     stw     r7,0(r3)        # return the quotient in *r3
>> +       stw     r8,4(r3)
>> +#endif
>>         mr      r3,r6           # return the remainder in r3
>>         blr
>
> This looks like a typo, since you didn't actually swap the offsets
> on the stw's like you did in all of the other patch hunks.
>
>
> Peter
>
>
>
>
