Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab1DXSzU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 14:55:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49762 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab1DXSzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 14:55:19 -0400
Message-ID: <4DB47211.90901@dynato-kyma.net>
Date: Sun, 24 Apr 2011 20:55:13 +0200
From: =?UTF-8?B?SsO2cmctVm9sa2VyIFBlZXR6?= <peetz@dynato-kyma.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        =?UTF-8?B?SsO2cmctVm9sa2VyIFBlZXR6?= <jvpeetz@web.de>,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: Linux 2.6.38.4 : regression due to x86 AMD ARAT feature
References: <20110421213926.GA19721@kroah.com> <4DB3DA0C.1050003@web.de> <20110424182041.GA19984@liondog.tnic>
In-Reply-To: <20110424182041.GA19984@liondog.tnic>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:BnNmgrdx9WTZN6VhubAxwBbzakmxQAxAGfzOCDlyEDQ
 Jy45ymwS3ojJP9Kjx7MQCD30gYp30nV/adHOwjJnF/GtAOXQIb
 zyox6ciTBTPZBdTfuisf2EgI87Js4MK3IcY2xtbBHF6mW/0I2z
 rZn2YKv1PvaDhtgu1oiHkPG0Ofd/pZVxR1jfwYtZ87japerFwm
 e9p2OsYv/mEV5MQYp/wWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote, on 04/24/11 20:20:
> On Sun, Apr 24, 2011 at 10:06:36AM +0200, Jörg-Volker Peetz wrote:
>> With 2.6.38.4 the clock slows down and the affected laptop sometimes, e.g. for
>> the output of "ps axuw" to appear, needs an input from the keyboard or the
>> touchpad. Please find attached the kernel config file and the output of dmesg.
>>
>> Commenting out the the lines
>>
>> 	if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
>> 		set_cpu_cap(c, X86_FEATURE_ARAT);
>>
>> in arch/x86/kernel/cpu/amd.c makes this laptop work as before with kernel
>> 2.6.38.3. I think these lines came with commit
>> d7b7f0c401303dd7eafcff11752fe74d3b75c766.
> 
> Hmm, interesting.
> 
> Can you send also /proc/cpuinfo please?
> 
> Looks like your CPU is a single core K8 revE or something but we'd need
> the exact family info.
> 
> Thanks.
> 

Here it comes:


processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 36
model name	: AMD Turion(tm) 64 Mobile Technology MT-40
stepping	: 2
cpu MHz		: 800.000
cache size	: 1024 KB
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36
clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt lm 3dnowext 3dnow rep_good
nopl pni lahf_lm
bogomips	: 1592.98
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

This is a nice mobile processor and i thought it was sold quite a lot.
-- 
Best regards,
Jörg-Volker.
