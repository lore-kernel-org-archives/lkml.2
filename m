Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab1DAVnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 17:43:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54494 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799Ab1DAVm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 17:42:59 -0400
Message-ID: <4D9646C6.7060301@zytor.com>
Date: Fri, 01 Apr 2011 14:42:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Michael Leun <lkml20101129@newton.leun.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mike Pagano <mpagano@gentoo.org>
Subject: Re: 2.6.38.2 breaks suspend to disk
References: <20110330203215.0a1a41a7@xenia.leun.net>	<20110331090524.07ad0069@xenia.leun.net>	<alpine.DEB.2.00.1103311546480.16492@kaball-desktop>	<201103312348.53678.rjw@sisk.pl>	<4D94FE37.8070109@kernel.org>	<alpine.DEB.2.00.1104011230550.16492@kaball-desktop>	<4D95F80D.7070201@kernel.org>	<4D95FBDD.9050901@zytor.com>	<alpine.DEB.2.00.1104011729000.16492@kaball-desktop>	<4D961FBC.2030105@zytor.com>	<4D962837.2070300@kernel.org>	<4D96294B.5050909@zytor.com>	<4D962D72.2010501@kernel.org>	<4D9633E7.1010707@zytor.com>	<AANLkTi=VzMh84szSBNujVU8oLZfzQd_z2bg+O3K_8GMd@mail.gmail.com>	<4D9643F1.1090807@zytor.com> <AANLkTimd22epcYvZRrvP5p3CzArpnR3To_mKCjdKKuf8@mail.gmail.com>
In-Reply-To: <AANLkTimd22epcYvZRrvP5p3CzArpnR3To_mKCjdKKuf8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 02:37 PM, Yinghai Lu wrote:
>>
>> Err, yes, that's what I meant.
>>
>> Now, why the heck did you introduce a bunch of CONFIG_HIBERNATION #ifdefs?
> 
> mmu_cr4_features: have two usages:
> 1. for 32bit to control cr4 access in head_32.S
> 2. for hibernation resume.
> 
> include/asm/processor.h:extern unsigned long            mmu_cr4_features;
> include/asm/processor.h:        mmu_cr4_features |= mask;
> include/asm/processor.h:        mmu_cr4_features &= ~mask;
> kernel/head_32.S:#define cr4_bits pa(mmu_cr4_features)
> kernel/setup.c: * mmu_cr4_features two purpose:
> kernel/setup.c:unsigned long mmu_cr4_features;
> kernel/setup.c:unsigned long mmu_cr4_features = X86_CR4_PAE;
> kernel/setup.c:         mmu_cr4_features = read_cr4();
> power/hibernate_asm_32.S:       movl    mmu_cr4_features, %ecx
> power/hibernate_asm_32.S:       movl    mmu_cr4_features, %ecx
> power/hibernate_asm_64.S:       movq    mmu_cr4_features(%rip), %rax
> power/hibernate_asm_64.S:       movq    mmu_cr4_features(%rip), %rax
> 
> So we don't need to read back cr4 and save it if CONFIG_HIBERNATION is
> not defined.
> 

And why on Earth is it worth saving a couple of instructions (and
introducing code ugliness and a more complex testing matrix) in the case
when it is not?

	-hpa
