Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab2FFJwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:52:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62292 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab2FFJwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:52:07 -0400
Date: Wed, 6 Jun 2012 11:52:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] x86/copy_user_generic: Optimize copy_user_generic with
 CPU erms feature
Message-ID: <20120606095201.GI9495@gmail.com>
References: <1337908785-14015-1-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337908785-14015-1-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> According to Intel 64 and IA-32 SDM and Optimization Reference Manual, beginning
> with Ivybridge, REG string operation using MOVSB and STOSB can provide both
> flexible and high-performance REG string operations in cases like memory copy.
> Enhancement availability is indicated by CPUID.7.0.EBX[9] (Enhanced REP MOVSB/
> STOSB).
> 
> If CPU erms feature is detected, patch copy_user_generic with enhanced fast
> string version of copy_user_generic.
> 
> A few new macros are defined to reduce duplicate code in ALTERNATIVE and
> ALTERNATIVE_2.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
> checkpatch.pl reports two errors in alternative_call_2() definition. I think
> the errors are invalid and should be ignored:
> ERROR: Macros with complex values should be enclosed in parenthesis
> ERROR: space prohibited before open square bracket '['

ok.

> 
>  arch/x86/include/asm/alternative.h |   74 ++++++++++++++++++++++++++++-------
>  arch/x86/include/asm/uaccess_64.h  |   11 +++++-
>  arch/x86/kernel/x8664_ksyms_64.c   |    1 +
>  3 files changed, 70 insertions(+), 16 deletions(-)

Looks good to me. Peter, Thomas, any objections?

Thanks,

	Ingo
