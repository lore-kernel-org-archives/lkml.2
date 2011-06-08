Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab1FHSWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 14:22:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab1FHSWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 14:22:08 -0400
Date: Wed, 8 Jun 2011 20:20:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make former thread ID available via PTRACE_GETEVENTMSG
	after PTRACE_EVENT_EXEC stop
Message-ID: <20110608182032.GA16264@redhat.com>
References: <BANLkTin6CmO+PfyGkUL3fg3REGXU=7DS7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin6CmO+PfyGkUL3fg3REGXU=7DS7g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08, Denys Vlasenko wrote:
>
> Not sure what kind of locking, if any, I need to put around
> current->parent...

Yes ;)

> @@ -1383,8 +1383,10 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
>  			 */
>  			bprm->recursion_depth = depth;
>  			if (retval >= 0) {
> -				if (depth == 0)
> -					tracehook_report_exec(fmt, bprm, regs);
> +				if (depth == 0) {
> +					pid_t pid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));

It is not safe to use ->parent. At least you need rcu lock around.

Also. At this point current has already changed its pid, you should
record pid_t before ->load_binary().

And. We have the coding style police, please use scripts/checkpatch.pl



Just in case, I'll be off-line till Monday.

Oleg.

