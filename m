Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab2CKSJM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 14:09:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab2CKSJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 14:09:09 -0400
Date: Sun, 11 Mar 2012 18:25:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Djalal Harouni <tixxdz@opendz.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>,
        Stephen Wilson <wilsons@start.ca>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH 1/9] exec: add a global execve counter
Message-ID: <20120311172512.GA2729@redhat.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org> <1331421919-15499-2-git-send-email-tixxdz@opendz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331421919-15499-2-git-send-email-tixxdz@opendz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11, Djalal Harouni wrote:
>
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1420,6 +1420,9 @@ struct task_struct {
>  #endif
>  	seccomp_t seccomp;
>
> +/* Execve counter: will be used to check if objects belong to the appropriate
> + * process image */
> +	atomic64_t exec_id;
>  /* Thread group tracking */
>     	u32 parent_exec_id;
>     	u32 self_exec_id;

Well, I don't think it is right to add this counter into task_struct.

It should be per-process, signal_struct makes more sense. Or may be
mm_struct.

Btw this is also true for parent_exec_id/self_exec_id, but this is
another story.

Oleg.

