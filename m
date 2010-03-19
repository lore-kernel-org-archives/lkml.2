Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0CSNfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 09:35:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab0CSNfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 09:35:44 -0400
Date: Fri, 19 Mar 2010 14:33:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Roland McGrath <roland@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH -tip v5] tracepoint: Add signal coredump tracepoint
Message-ID: <20100319133352.GC19394@redhat.com>
References: <20100319132346.31144.40337.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319132346.31144.40337.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add Neil)

On 03/19, Masami Hiramatsu wrote:
>
>  void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>  {
>  	struct core_state core_state;
> -	char corename[CORENAME_MAX_SIZE + 1];
> +	char corename[CORENAME_MAX_SIZE + 1] = "";
>  	struct mm_struct *mm = current->mm;
>  	struct linux_binfmt * binfmt;
>  	struct inode * inode;
> @@ -1802,6 +1803,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>  	static atomic_t core_dump_count = ATOMIC_INIT(0);
>  	struct coredump_params cprm = {
>  		.signr = signr,
> +		.file = NULL,
>  		.regs = regs,
>  		.limit = rlimit(RLIMIT_CORE),
>  		/*
> @@ -1815,8 +1817,10 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>  	audit_core_dumps(signr);
>
>  	binfmt = mm->binfmt;
> -	if (!binfmt || !binfmt->core_dump)
> +	if (!binfmt || !binfmt->core_dump) {
> +		retval = -ENOSYS;
>  		goto fail;
> +	}

Oh.

Masami, may I ask you to delay these changes a bit?

This patch conflicts very much with other changes (hopefully in -mm soon)
we are doing.

If your patch comes first, we have to redo 12 patches. Besides, this patch
complicates do_coredump() even more while it really needs the cleanups.

Please see
http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/96f01d85034ca029/3b6bcb9b2d756dbc
I can send you these patches privately if you wish.

Oleg.

