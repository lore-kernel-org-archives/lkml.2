Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2HZLaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 07:30:16 -0400
Received: from mail.x86-64.org ([217.9.48.20]:56847 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab2HZLaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 07:30:14 -0400
Date: Sun, 26 Aug 2012 13:30:01 +0200
From: Borislav Petkov <bp@amd64.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, robert.richter@amd.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] x86, fpu: remove unnecessary user_fpu_end() in
 save_xstate_sig()
Message-ID: <20120826113001.GA19227@aftab.osrc.amd.com>
References: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
 <1345842782-24175-3-git-send-email-suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345842782-24175-3-git-send-email-suresh.b.siddha@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 02:12:58PM -0700, Suresh Siddha wrote:
> Few lines below we do drop_fpu() which is more safer. Remove the
> unnecessary user_fpu_end() in save_xstate_sig(), which allows
> the drop_fpu() to ignore any pending exceptions from the user-space
> and drop the current fpu.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  arch/x86/include/asm/fpu-internal.h |   17 +++--------------
>  arch/x86/kernel/xsave.c             |    1 -
>  2 files changed, 3 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
> index fe95ad0..fac39e9 100644
> --- a/arch/x86/include/asm/fpu-internal.h
> +++ b/arch/x86/include/asm/fpu-internal.h
> @@ -412,22 +412,11 @@ static inline void __drop_fpu(struct task_struct *tsk)
>  }
>  
>  /*
> - * The actual user_fpu_begin/end() functions
> - * need to be preemption-safe.
> + * Need to be preemption-safe.
>   *
> - * NOTE! user_fpu_end() must be used only after you
> - * have saved the FP state, and user_fpu_begin() must
> - * be used only immediately before restoring it.
> - * These functions do not do any save/restore on
> - * their own.
> + * NOTE! user_fpu_begin() must be used only immediately before restoring
> + * it. This function does not do any save/restore on their own.
>   */
> -static inline void user_fpu_end(void)
> -{
> -	preempt_disable();
> -	__thread_fpu_end(current);
> -	preempt_enable();
> -}

Now that user_fpu_begin has lost its counterpart user_fpu_end, maybe
rename it to user_fpu_init() or something similar which doesn't suggest
there's a _begin and an _end thingy?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
