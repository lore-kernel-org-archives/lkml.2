Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935509Ab2JXTz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:55:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54911 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964877Ab2JXTzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:55:23 -0400
Date: Wed, 24 Oct 2012 21:55:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: danielfsantos@att.net
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
Subject: Re: [PATCH v3 04/10] bug.h: directly include linux/compiler.h
Message-ID: <20121024195520.GD17945@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, danielfsantos@att.net,
	LKML <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>,
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
References: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
 <1351096441-12388-4-git-send-email-daniel.santos@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1351096441-12388-4-git-send-email-daniel.santos@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 11:33:55AM -0500, danielfsantos@att.net wrote:
> Currently, we are only including asm/bug.h and then expecting that
> linux/compiler.h will eventually be included to define __linktime_error
> (used in BUILD_BUG_ON). This patch includes it directly for clarity and
> to avoid the possibility of changes in <arch>/*/include/asm/bug.h being
> changed or not including linux/compiler.h for some reason. (Later
> patches will in this set use more macros defined in compiler*.h.)
> 
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> ---
>  include/linux/bug.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/bug.h b/include/linux/bug.h
> index aaac4bb..4bd74d8 100644
> --- a/include/linux/bug.h
> +++ b/include/linux/bug.h
> @@ -2,6 +2,7 @@
>  #define _LINUX_BUG_H
>  
>  #include <asm/bug.h>
> +#include <linux/compiler.h>
>  
>  enum bug_trap_type {
>  	BUG_TRAP_TYPE_NONE = 0,
> -- 
> 1.7.3.4

Why is this a separate patch and why not add that single line in 6/10
where you define BUILD_BUG_ON?

Thanks.

-- 
Regards/Gruss,
    Boris.
