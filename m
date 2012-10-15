Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab2JOWOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 18:14:16 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53630 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab2JOWOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 18:14:15 -0400
Date: Mon, 15 Oct 2012 23:14:06 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-ID: <20121015221406.GA19848@arm.com>
References: <20121015130728.06a0da8ae06c362aed2871fa@canb.auug.org.au>
MIME-Version: 1.0
In-Reply-To: <20121015130728.06a0da8ae06c362aed2871fa@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 15 Oct 2012 22:14:12.0717 (UTC) FILETIME=[6816B9D0:01CDAB22]
X-MC-Unique: 112101523141302001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Oct 15, 2012 at 03:07:28AM +0100, Stephen Rothwell wrote:
> Today's linux-next merge of the akpm tree got a conflict in
> arch/arm64/include/asm/unistd32.h between commit f3d447a97f24 ("arm64: Do
> not include asm/unistd32.h in asm/unistd.h") from Linus' tree and commit
> "compat: generic compat_sys_sched_rr_get_interval implementation" from
> the akpm tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
> index 63f853f..0f13ca8 100644
> --- a/arch/arm64/include/asm/unistd.h
> +++ b/arch/arm64/include/asm/unistd.h
> @@ -25,5 +25,6 @@
>  #define __ARCH_WANT_SYS_SIGPROCMASK
>  #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
>  #define __ARCH_WANT_COMPAT_SYS_SENDFILE
> +#define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
>  #endif
>  #include <uapi/asm/unistd.h>

The fix is correct (I moved the __ARCH_WANT_* from unistd32.h to
unistd.h) but I'll post another version of the patch tomorrow for Andrew
to merge.

Thanks.

-- 
Catalin

