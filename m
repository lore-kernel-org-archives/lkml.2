Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1HVNfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:35:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab1HVNfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:35:42 -0400
Date: Mon, 22 Aug 2011 15:32:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: bookjovi@gmail.com
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] coredump: fix wrong comments on core limits of pipe
	coredump case
Message-ID: <20110822133244.GA28449@redhat.com>
References: <1314048011-2824-1-git-send-email-bookjovi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314048011-2824-1-git-send-email-bookjovi@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, I thought you are going to re-do this patch...

On 08/22, bookjovi@gmail.com wrote:
>
> Only core limit 1 can skip dump in ispipe case, not 0.

Yes, but this is (almost) internal hack we use to avoid the recursive
crashes.

> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -2163,7 +2163,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>  			 * we're not writing to the file system, but we use
>  			 * cprm.limit of 1 here as a speacial value. Any
>  			 * non-1 limit gets set to RLIM_INFINITY below, but
> -			 * a limit of 0 skips the dump.  This is a consistent
> +			 * a limit of 1 skips the dump.  This is a consistent

I'd suggest to simple remove the "skips the dump" part.

To me, we can also remove the "Note that we use task_tgid_vnr" part,
but feel free to ignore. Every user of task_tgid_vnr() could have the
same comment.

Oleg.

