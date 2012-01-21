Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab2AUJEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 04:04:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57944 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab2AUJEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 04:04:22 -0500
Date: Sat, 21 Jan 2012 10:03:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Vasiliy Kulikov <segoon@openwall.com>,
        Dan Ballard <dan@mindstab.net>, Jiri Kosina <jkosina@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, Stephen Wilson <wilsons@start.ca>,
        David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] sysctl: control functionality of /proc/pid/mem
Message-ID: <20120121090342.GD32134@elte.hu>
References: <20120121084317.GA30541@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120121084317.GA30541@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> @@ -702,6 +704,9 @@ static int mem_open(struct inode* inode, struct file* file)
>  	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
>  	struct mm_struct *mm;
>  
> +	if (sysctl_proc_pid_mem < 1)
> +		return -EACCES;

This looks like an unprivileged user-space triggerable memory 
leak DoS. The task reference is already acquired at that point.

See how easy it is to introduce bugs with potential security 
side-effects, even when the intention is to increase security?
:-)

( Btw., this is why i generally prefer 'invariant' local
  variable definition blocks that have no serious side effects -
  it makes the flow more obvious. Local variables slip off the 
  eye rather often and don't register as 'real' code.)

Thanks,

	Ingo
