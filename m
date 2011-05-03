Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab1ECVqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:46:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755133Ab1ECVqF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:46:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110503205051.GA28647@elte.hu>
References: <web-516671337@zbackend1.aha.ru> <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com>
 <web-516990066@zbackend1.aha.ru> <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
 <20110503190822.GA20520@elte.hu> <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <4DC06386.8090206@zytor.com> <20110503205051.GA28647@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 May 2011 14:45:10 -0700
Message-ID: <BANLkTin0QqwmOw2xYic0MVgvm4Rk13-yHQ@mail.gmail.com>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, werner <w.landgraf@ru.ru>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 3, 2011 at 1:50 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> the ELAN .config option influences the following details:
>
>  - sets X86_L1_CACHE_SHIFT to 4 (16 bytes) instead of the typical 6 (64 bytes)
>  - sets X86_ALIGNMENT_16
>  - sets the -march=i486 compiler flag

It also does this to the config diff:

  306,307c328,332
  < CONFIG_X86_ALIGNMENT_16=y
  < CONFIG_X86_MINIMUM_CPU_FAMILY=4
  ---
  > CONFIG_X86_USE_PPRO_CHECKSUM=y
  > CONFIG_X86_TSC=y
  > CONFIG_X86_CMPXCHG64=y
  > CONFIG_X86_CMOV=y
  > CONFIG_X86_MINIMUM_CPU_FAMILY=5

because of all the indirect changes it causes.

Now, Werner is actually _running_ on an AMD Opteron (or whatever
family 15 is), I think. And his kernel is SMP-enabled. And that whole
thin looks really really iffy.

How/why do we even allow that combination of SMP and (for example)
arch/x86/lib/atomic64_386_32.S to be picked?

I don't think he actually runs SMP, but the fact that we even allow
that combination looks really odd/iffy. Am I missing something?

                        Linus
