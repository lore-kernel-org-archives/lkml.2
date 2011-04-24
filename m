Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab1DXToh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 15:44:37 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:26962
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755167Ab1DXTod convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 15:44:33 -0400
X-SpamScore: -39
X-BigFish: VPS-39(z21eRzbb2dK1803M9371O179dN1432N98dKzz1202hzzz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LK69I1-01-AU9-02
X-M-MSG: 
From: "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>
To: =?iso-8859-1?Q?J=F6rg-Volker_Peetz?= <peetz@dynato-kyma.net>,
        Borislav Petkov <bp@alien8.de>,
        =?iso-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Date: Sun, 24 Apr 2011 14:44:26 -0500
Subject: RE: Linux 2.6.38.4 : regression due to x86 AMD ARAT feature
Thread-Topic: Linux 2.6.38.4 : regression due to x86 AMD ARAT feature
Thread-Index: AcwCsSjG9M+ejtYmS52SaBQX1R83hgABXLiN
Message-ID: <EE335F95F28A664DB4A21289D2AA053BD1807651@SAUSEXMBP01.amd.com>
References: <20110421213926.GA19721@kroah.com> <4DB3DA0C.1050003@web.de>
 <20110424182041.GA19984@liondog.tnic>,<4DB47211.90901@dynato-kyma.net>
In-Reply-To: <4DB47211.90901@dynato-kyma.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's an old family fh processor (CPUID 00020F42) that cpu_has_amd_erratum(amd_erratum_400) apparently hasn't picked up. Since all fh processors are affected by this erratum I'll replace "c->x86 >= 0xf" with "c->x86 > 0xf" (and probably fix erratum formula anyway).

-boris
________________________________________
From: Jörg-Volker Peetz [peetz@dynato-kyma.net]
Sent: Sunday, April 24, 2011 2:55 PM
To: Borislav Petkov; Jörg-Volker Peetz; linux-kernel@vger.kernel.org; Ostrovsky, Boris; Herrmann3, Andreas; Petkov, Borislav
Subject: Re: Linux 2.6.38.4 : regression due to x86 AMD ARAT feature

Borislav Petkov wrote, on 04/24/11 20:20:
> On Sun, Apr 24, 2011 at 10:06:36AM +0200, Jörg-Volker Peetz wrote:
>> With 2.6.38.4 the clock slows down and the affected laptop sometimes, e.g. for
>> the output of "ps axuw" to appear, needs an input from the keyboard or the
>> touchpad. Please find attached the kernel config file and the output of dmesg.
>>
>> Commenting out the the lines
>>
>>      if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
>>              set_cpu_cap(c, X86_FEATURE_ARAT);
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


processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 36
model name      : AMD Turion(tm) 64 Mobile Technology MT-40
stepping        : 2
cpu MHz         : 800.000
cache size      : 1024 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36
clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt lm 3dnowext 3dnow rep_good
nopl pni lahf_lm
bogomips        : 1592.98
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

This is a nice mobile processor and i thought it was sold quite a lot.
--
Best regards,
Jörg-Volker.


