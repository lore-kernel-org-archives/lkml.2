Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab0CPWFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 18:05:44 -0400
Received: from mx6.orcon.net.nz ([219.88.242.56]:60168 "EHLO mx6.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab0CPWFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 18:05:42 -0400
Cc: Will L Givens <wlgivens@gmail.com>, dl8bcu@dl8bcu.de,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Message-Id: <4AB85842-79DF-412F-833C-4B784353A1F5@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: Matt Turner <mattst88@gmail.com>
In-Reply-To: <b4198de61003161439s1fc43b75v45595b475053b3d@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: Will's kernel compilation error
Date: Wed, 17 Mar 2010 11:05:34 +1300
References: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com> <001e01cac4cc$98072ce0$c81586a0$@com> <20100316182534.GA818@ds20.borg.net> <006e01cac54e$dd6b7b10$98427130$@com> <b4198de61003161439s1fc43b75v45595b475053b3d@mail.gmail.com>
X-Mailer: Apple Mail (2.936)
X-DSPAM-Check: by mx6.orcon.net.nz on Wed, 17 Mar 2010 11:05:37 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Mar 17 11:05:39 2010
X-DSPAM-Confidence: 0.8525
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/03/2010, at 10:39 AM, Matt Turner wrote:
> On Tue, Mar 16, 2010 at 5:23 PM, Will L Givens <wlgivens@gmail.com>  
> wrote:
>>
>>> when I hit the relocation overflow a couple of releases before, I
>>> locally
>>> applied this patch, which fixes it for me. I assume the kernel is
>>> slightly
>>> bigger this way, but I didn't measure it.
>>>
>>> diff --git a/arch/alpha/Makefile b/arch/alpha/Makefile
>>> index 4759fe7..2cc3cc5 100644
>>> --- a/arch/alpha/Makefile
>>> +++ b/arch/alpha/Makefile
>>> @@ -12,7 +12,7 @@ NM := $(NM) -B
>>>
>>>  LDFLAGS_vmlinux      := -static -N #-relax
>>>  CHECKFLAGS   += -D__alpha__ -m64
>>> -cflags-y     := -pipe -mno-fp-regs -ffixed-8 -msmall-data
>>> +cflags-y     := -pipe -mno-fp-regs -ffixed-8
>>>  cflags-y     += $(call cc-option, -fno-jump-tables)
>>>
>>>  cpuflags-$(CONFIG_ALPHA_EV4)         := -mcpu=ev4
>>
>> That patch did the trick!!!! Everything built without issue... I'll  
>> post
>> your patch at bugzilla.kernel.org.
>
> Don't post it to bugzilla. It'll just rot there.
>
> The author should mail linux-alpha@ to get it reviewed.


The patch is not suitable, IMHO, for the kernel as it stands.  Some of  
us prefer the small-data model as we must boot off a slow medium that  
is supported by SRM.  Using large-data results in a larger code size.

It would be nice if the build system could detect the need for the  
large-data model before compilation but I can't see how to do that  
without actually compiling the kernel.

Therefore I suggest a kernel config item be added to optionally remove  
the -msmall-data compiler option for those who are building kernels  
with data areas greater than 64kB.  I'll drum up a patch later today.

Cheers
Michael.

