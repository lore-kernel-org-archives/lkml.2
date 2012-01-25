Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab2AYJIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 04:08:50 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39097 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2AYJIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 04:08:46 -0500
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] If init dies, log a signal which killed it, if any.
Date: Wed, 25 Jan 2012 10:08:42 +0100
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
References: <1327097836-8485-1-git-send-email-vda.linux@googlemail.com> <20120124162016.08a37b2f.akpm@linux-foundation.org>
In-Reply-To: <20120124162016.08a37b2f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201201251008.42120.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 January 2012 01:20, Andrew Morton wrote:
> It's a bit user-hostile to print a hex number in such a context without
> the leading 0x.  The %08 does provide a hint - users are unlikely to
> interpret 00000011 as 11.  But still, I think...
> 
> --- a/kernel/exit.c~kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix
> +++ a/kernel/exit.c
> @@ -711,7 +711,7 @@ static struct task_struct *find_new_reap
>  	if (unlikely(pid_ns->child_reaper == father)) {
>  		write_unlock_irq(&tasklist_lock);
>  		if (unlikely(pid_ns == &init_pid_ns)) {
> -			panic("Attempted to kill init! exitcode=%08x\n",
> +			panic("Attempted to kill init! exitcode=0x%08x\n",
>  				father->signal->group_exit_code ?:
>  					father->exit_code);
>  		}
> _

Looks good to me.

> Or maybe we should use %d.  Does anyone use hex for exit codes?

I guess hex is better, considering that normal (non-signal) exit code
is stored in bits 8-15. It's more readable to see exit code 3 as 0x300
then as 768.

-- 
vda
