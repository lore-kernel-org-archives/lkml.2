Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab2JGTnO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 15:43:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45345 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab2JGTnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 15:43:05 -0400
Date: Sun, 7 Oct 2012 21:42:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 03/10] compiler-gcc{3,4}.h: Use GCC_VERSION macro
Message-ID: <20121007194259.GA25313@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel Santos <daniel.santos@pobox.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christopher Li <sparse@chrisli.org>,
	David Daney <david.daney@cavium.com>,
	David Howells <dhowells@redhat.com>,
	David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Pavel Pisa <pisa@cmp.felk.cvut.cz>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Steven Rostedt <rostedt@goodmis.org>
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
 <1349466169-20637-3-git-send-email-daniel.santos@pobox.com>
 <20121006231041.GB3278@liondog.tnic>
 <5071C9AE.2010106@att.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5071C9AE.2010106@att.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 01:27:58PM -0500, Daniel Santos wrote:
> > Did I miss something again? This "error" preprocessor function is
> > commented out here? Why?
> We'll have to ask Andrew.  Maybe so he can test on those versions of gcc?
> 
> commit d3ffe64a1dbcfe18b57f90f7c01c40c93d0a8b92
> Author: Andrew Morton <akpm@linux-foundation.org>
> Date:   Fri Sep 28 00:02:42 2012 +0000
> 
>     a
>    
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
> index 934bc34..997fd8a 100644
> --- a/include/linux/compiler-gcc4.h
> +++ b/include/linux/compiler-gcc4.h
> @@ -5,7 +5,7 @@
>  /* GCC 4.1.[01] miscompiles __weak */
>  #ifdef __KERNEL__
>  # if __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1
> -#  error Your version of gcc miscompiles the __weak directive
> +//#  error Your version of gcc miscompiles the __weak directive
>  # endif
>  #endif

Ah, interesting. I think akpm has been redoing -mm couple times recently
so you probably caught a temporary thing.

> I can provide you a version of these patches rebased against Linus if
> you like, which I am using to test since the -mm & -next trees aren't
> working on my machine (hardware, .config and/or LVM/RAID setup). I
> haven't put Walken's patches underneath them however.

Nah, not necessary. I'd simply wait after the merge window closes and
everything settles down and then crank out a patchset against one of
the major trees (say -mm, linus or -next) so we can agree on the final
versions. AFAICT, the general design is fine - it's just the details
that need to be hammered out with precision.

Thanks.

-- 
Regards/Gruss,
    Boris.
