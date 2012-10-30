Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab2J3TTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:19:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50185 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab2J3TTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:19:10 -0400
Date: Tue, 30 Oct 2012 20:19:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v4 9/9] bug.h: Convert BUILD_BUG{,_ON} to use
 BUILD_BUG_ON_MSG
Message-ID: <20121030191905.GG28499@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel Santos <daniel.santos@pobox.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christopher Li <sparse@chrisli.org>,
	David Daney <david.daney@cavium.com>,
	David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Pavel Pisa <pisa@cmp.felk.cvut.cz>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Steven Rostedt <rostedt@goodmis.org>,
	David Rientjes <rientjes@google.com>
References: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
 <1351457835-7553-9-git-send-email-daniel.santos@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1351457835-7553-9-git-send-email-daniel.santos@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 03:57:15PM -0500, danielfsantos@att.net wrote:
> Remove duplicate code by converting BUILD_BUG and BUILD_BUG_ON to just
> call BUILD_BUG_ON_MSG.  This not only reduces source code bloat, but
> also prevents the possibility of code being changed for one macro and
> not for the other (which was previously the case for BUILD_BUG and
> BUILD_BUG_ON).
> 
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> ---
>  include/linux/bug.h |   17 +++--------------
>  1 files changed, 3 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/bug.h b/include/linux/bug.h
> index 3bc1ddf..b58ba51 100644
> --- a/include/linux/bug.h
> +++ b/include/linux/bug.h
> @@ -81,14 +81,8 @@ struct pt_regs;
>  #ifndef __OPTIMIZE__
>  #define BUILD_BUG_ON(condition) __compiletime_error_fallback(condition)
>  #else
> -#define BUILD_BUG_ON(condition)						\
> -	do {								\
> -		extern void __build_bug_on_failed(void)			\
> -			__compiletime_error("BUILD_BUG_ON failed");	\
> -		__compiletime_error_fallback(condition);		\
> -		if (condition)						\
> -			__build_bug_on_failed();			\
> -	} while(0)
> +#define BUILD_BUG_ON(condition) \
> +	BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)

Concatenating "condition" might not be very informative in all cases.
For example:

BUILD_BUG_ON(1);

Having __LINE__ is good enough IMHO.

Thanks.

-- 
Regards/Gruss,
    Boris.
