Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2HTSvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:51:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50025 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155Ab2HTSvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:51:49 -0400
Message-ID: <50328722.9060009@zytor.com>
Date: Mon, 20 Aug 2012 11:51:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 00/11] x86/microcode: Early load microcode
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com> <20120820153927.GB8623@aftab.osrc.amd.com>
In-Reply-To: <20120820153927.GB8623@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 08:39 AM, Borislav Petkov wrote:
> On Sat, Aug 18, 2012 at 01:15:18AM -0700, Fenghua Yu wrote:
>>  Documentation/x86/earlyucode.txt        |   43 +++
>>  arch/x86/Kconfig                        |   22 ++
>>  arch/x86/include/asm/cpio.h             |   10 +
>>  arch/x86/include/asm/microcode.h        |   23 ++
>>  arch/x86/include/asm/microcode_intel.h  |  103 +++++++
>>  arch/x86/kernel/Makefile                |    3 +
>>  arch/x86/kernel/head64.c                |    6 +
>>  arch/x86/kernel/head_32.S               |    6 +
>>  arch/x86/kernel/microcode_core.c        |    7 +-
>>  arch/x86/kernel/microcode_core_early.c  |   74 +++++
>>  arch/x86/kernel/microcode_intel.c       |  185 +------------
>>  arch/x86/kernel/microcode_intel_early.c |  482 +++++++++++++++++++++++++++++++
>>  arch/x86/kernel/microcode_intel_lib.c   |  163 +++++++++++
> 
> One more thing:
> 
> This screams for adding a directory called "microcode" in the kernel
> sources and moving all the microcode-related files there. IOW:
> 
> arch/x86/kernel/cpu/microcode/core.c
> arch/x86/kernel/cpu/microcode/core_early.c
> arch/x86/kernel/cpu/microcode/intel.c
> arch/x86/kernel/cpu/microcode/amd.c
> ...
> 
> And yes, they should be under "cpu" too.
> 

Not really, but that isn't even Fenghua's fault.

The cpu directory was originally for cpu detection.  The whole kernel/
directory, of course, is a morass that might as well be called "misc".
Some things are legitimately there -- mainly the syscall table and
things that mirror the global kernel/ -- but a ton of stuff doesn't make
any sense there.

Reorganizing the kernel/ directory and promoting cpu up one level would
make that make more sense.  The pci and irq code are examples of things
that could use their own directories.

	-hpa
