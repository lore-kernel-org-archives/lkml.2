Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab0CPVrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:47:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55690 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab0CPVrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:47:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RWM7su4ZjrdpIxQ5MKaR+Ust+SK7Y9yB59PePkWj651w+0TFpRPWyKvYvigS0blul/
         LZQqtf/UDRAYvxTaeWaig5xtcbT3T0GNXcmlQLRumpmsOMduCrlXttYQUhKivkRX4w2/
         5eczsqZ9aKczmcFs7VmpAAaiekGTNiyyVM6NE=
MIME-Version: 1.0
In-Reply-To: <006e01cac54e$dd6b7b10$98427130$@com>
References: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com>
	 <001e01cac4cc$98072ce0$c81586a0$@com>
	 <20100316182534.GA818@ds20.borg.net>
	 <006e01cac54e$dd6b7b10$98427130$@com>
Date: Tue, 16 Mar 2010 17:39:56 -0400
Message-ID: <b4198de61003161439s1fc43b75v45595b475053b3d@mail.gmail.com>
Subject: Re: Will's kernel compilation error
From: Matt Turner <mattst88@gmail.com>
To: Will L Givens <wlgivens@gmail.com>
Cc: dl8bcu@dl8bcu.de, linux-kernel@vger.kernel.org,
       linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 5:23 PM, Will L Givens <wlgivens@gmail.com> wrote:
>> >
>> > It seems the problem, GPREL16, is pretty wide spread. I've tried
>> building
>> > the drivers as modules, since that doesn't appear to be a problem
>> *knock on
>> > wood* but one driver after another, after another, after another
>> generates a
>> > new GPREL16 error! Raid0 drivers, numerous NetFilter modules, IR
>> drivers
>> > (guess I can't use a Hauppauge card), and various other components.
>> I'm
>> > going to try a few more configurations... then hit the sack. I'm
>> pretty sure
>> > this is going to be a long process.
>>
>> when I hit the relocation overflow a couple of releases before, I
>> locally
>> applied this patch, which fixes it for me. I assume the kernel is
>> slightly
>> bigger this way, but I didn't measure it.
>>
>> ev6, everything built in, gcc 4.4 I think
>>
>> Thorsten
>>
>>
>> diff --git a/arch/alpha/Makefile b/arch/alpha/Makefile
>> index 4759fe7..2cc3cc5 100644
>> --- a/arch/alpha/Makefile
>> +++ b/arch/alpha/Makefile
>> @@ -12,7 +12,7 @@ NM := $(NM) -B
>>
>>  LDFLAGS_vmlinux      := -static -N #-relax
>>  CHECKFLAGS   += -D__alpha__ -m64
>> -cflags-y     := -pipe -mno-fp-regs -ffixed-8 -msmall-data
>> +cflags-y     := -pipe -mno-fp-regs -ffixed-8
>>  cflags-y     += $(call cc-option, -fno-jump-tables)
>>
>>  cpuflags-$(CONFIG_ALPHA_EV4)         := -mcpu=ev4
>>
>>
>> --
>> | Thorsten Kranzkowski        Internet: dl8bcu@dl8bcu.de
>> |
>> | Mobile: ++49 170 1876134       Snail: Kiebitzstr. 14, 49324 Melle,
>> Germany  |
>> | Ampr: dl8bcu@db0lj.#rpl.deu.eu, dl8bcu@marvin.dl8bcu.ampr.org
>> [44.130.8.19] |
>
> That patch did the trick!!!! Everything built without issue... I'll post
> your patch at bugzilla.kernel.org. Now, just have to test the AIC7xxx driver
> and see if it works!  Nope it doesn't, same error as before... aic7xxx
> unable to handle kernel paging address at 036b***** I'm going to try
> swapping some memory around and see what happens if anything.
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-alpha" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Don't post it to bugzilla. It'll just rot there.

The author should mail linux-alpha@ to get it reviewed.

Matt
