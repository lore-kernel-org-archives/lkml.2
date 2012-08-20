Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab2HTPjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:39:42 -0400
Received: from mail.x86-64.org ([217.9.48.20]:52969 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab2HTPjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:39:37 -0400
Date: Mon, 20 Aug 2012 17:39:27 +0200
From: Borislav Petkov <bp@amd64.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 00/11] x86/microcode: Early load microcode
Message-ID: <20120820153927.GB8623@aftab.osrc.amd.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 01:15:18AM -0700, Fenghua Yu wrote:
>  Documentation/x86/earlyucode.txt        |   43 +++
>  arch/x86/Kconfig                        |   22 ++
>  arch/x86/include/asm/cpio.h             |   10 +
>  arch/x86/include/asm/microcode.h        |   23 ++
>  arch/x86/include/asm/microcode_intel.h  |  103 +++++++
>  arch/x86/kernel/Makefile                |    3 +
>  arch/x86/kernel/head64.c                |    6 +
>  arch/x86/kernel/head_32.S               |    6 +
>  arch/x86/kernel/microcode_core.c        |    7 +-
>  arch/x86/kernel/microcode_core_early.c  |   74 +++++
>  arch/x86/kernel/microcode_intel.c       |  185 +------------
>  arch/x86/kernel/microcode_intel_early.c |  482 +++++++++++++++++++++++++++++++
>  arch/x86/kernel/microcode_intel_lib.c   |  163 +++++++++++

One more thing:

This screams for adding a directory called "microcode" in the kernel
sources and moving all the microcode-related files there. IOW:

arch/x86/kernel/cpu/microcode/core.c
arch/x86/kernel/cpu/microcode/core_early.c
arch/x86/kernel/cpu/microcode/intel.c
arch/x86/kernel/cpu/microcode/amd.c
...

And yes, they should be under "cpu" too.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
