Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2B0Gbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 01:31:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44130 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab2B0Gbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 01:31:45 -0500
Message-ID: <4F4B232F.2070605@zytor.com>
Date: Sun, 26 Feb 2012 22:31:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alex Shi <alex.shi@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: build failure after merge of the akpm tree
References: <20120227172139.726ddae85c910cee7b7e3a37@canb.auug.org.au>
In-Reply-To: <20120227172139.726ddae85c910cee7b7e3a37@canb.auug.org.au>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2012 10:21 PM, Stephen Rothwell wrote:
> 
> I applied the following fix up patch.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au> Date: Mon, 27 Feb
> 2012 17:12:00 +1100 Subject: [PATCH] percpu: fix for removal of
> percpu_xxx function
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au> --- 
> arch/x86/include/asm/compat.h |    2 +- 1 files changed, 1
> insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/compat.h
> b/arch/x86/include/asm/compat.h index e7f68b4..b6a2a1c 100644 ---
> a/arch/x86/include/asm/compat.h +++
> b/arch/x86/include/asm/compat.h @@ -229,7 +229,7 @@ static inline
> void __user *arch_compat_alloc_user_space(long len) sp =
> task_pt_regs(current)->sp; } else { /* -128 for the x32 ABI redzone
> */ -		sp = percpu_read(old_rsp) - 128; +		sp =
> __this_cpu_read(old_rsp) - 128; }
> 
> return (void __user *)round_down(sp - len, 16);

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

