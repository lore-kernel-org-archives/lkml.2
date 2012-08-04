Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2HDGnM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 02:43:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47578 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab2HDGnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 02:43:10 -0400
Date: Sat, 4 Aug 2012 08:43:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alex Kelly <eshink@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alex Kelly <alex.page.kelly@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Moved core dump functionality into its own file
Message-ID: <20120804064304.GA5195@gmail.com>
References: <1344027800-8270-1-git-send-email-eshink@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344027800-8270-1-git-send-email-eshink@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alex Kelly <eshink@gmail.com> wrote:

> From: Alex Kelly <alex.page.kelly@gmail.com>
> 
> This was done in preparation for making core dump functionality optional.

Please use present tense and a sane title, something like:

  fs: Move core dump functionality into its own file
  fs: Make core dump functionality optional

While looking at that code, there's also a few uglies in it, 
like:

> +	return nr;
> +}
> +
> +
> +/*

> +
> +	/* Repeat as long as we have more pattern to process and more output
> +	   space */

> +}
> +
> +
> +void do_coredump(long signr, int exit_code, struct pt_regs *regs)

> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -413,6 +413,7 @@ static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
>  
>  extern void set_dumpable(struct mm_struct *mm, int value);
>  extern int get_dumpable(struct mm_struct *mm);
> +extern int __get_dumpable(unsigned long mm_flags);

These prototypes should move out of sched.h and into a 
coredump.h header or so.

If we are touching this code lets use the opportunity and do 
this right.

Note, I'd suggest to put any such further changes into separate, 
additional patches at the end: a cleanup patch, a header file 
introduction patch, etc. - and keep the "dumb code movement" 
chnage in the initial patch. This will make it all much easier 
to review.

Please also review the code for more uglies, the above was just 
a very quick stylistic scan.

Thanks,

	Ingo
