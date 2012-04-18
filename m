Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab2DRRiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:38:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36722 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2DRRiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:38:05 -0400
MIME-Version: 1.0
In-Reply-To: <tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
	<tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org>
Date: Wed, 18 Apr 2012 10:38:03 -0700
Message-ID: <CAMe9rOqF6Kh6-NK7oP0Fpzkd4SBAWU+G53hwBbSD4iA2UzyxuA@mail.gmail.com>
Subject: Re: [tip:x86/x32] x32: Fix alignment fail in struct compat_siginfo
From: "H.J. Lu" <hjl.tools@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 2:43 PM, tip-bot for H. Peter Anvin
<hpa@zytor.com> wrote:
> Commit-ID:  31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4
> Gitweb:     http://git.kernel.org/tip/31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4
> Author:     H. Peter Anvin <hpa@zytor.com>
> AuthorDate: Wed, 14 Mar 2012 14:27:52 -0700
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Wed, 14 Mar 2012 14:27:52 -0700
>
> x32: Fix alignment fail in struct compat_siginfo
>
> Adding struct _sigchld_x32 caused a misalignment cascade in struct
> siginfo, because union _sifields is located on an 4-byte boundary
> (8-byte misaligned.)
>
> Adding new fields that are 8-byte aligned caused the intermediate
> structures to also be aligned to 8 bytes, thereby adding padding in
> unexpected places.
>
> Thus, change s64 to compat_s64 here, which makes it "misaligned on
> paper".  In reality these fields *are* actually aligned (there are 3
> preceeding ints outside the union and 3 inside struct _sigchld_x32),
> but because of the intervening union and struct it is not possible for
> gcc to avoid padding without breaking the ABI.
>
> Reported-and-tested-by: H. J. Lu <hjl.tools@gmail.com>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Link: http://lkml.kernel.org/r/1329696488-16970-1-git-send-email-hpa@zytor.com
> ---
>  arch/x86/include/asm/ia32.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/ia32.h b/arch/x86/include/asm/ia32.h
> index 7d0c185..ee52760 100644
> --- a/arch/x86/include/asm/ia32.h
> +++ b/arch/x86/include/asm/ia32.h
> @@ -130,8 +130,8 @@ typedef struct compat_siginfo {
>                        unsigned int _pid;      /* which child */
>                        unsigned int _uid;      /* sender's uid */
>                        int _status;            /* exit code */
> -                       s64 _utime;
> -                       s64 _stime;
> +                       compat_s64 _utime;
> +                       compat_s64 _stime;
>                } _sigchld_x32;
>
>                /* SIGILL, SIGFPE, SIGSEGV, SIGBUS */

It doesn't match struct siginfo in include/asm-generic/siginfo.h for
x32.

-- 
H.J.
