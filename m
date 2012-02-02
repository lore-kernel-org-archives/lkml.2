Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab2BBX0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:26:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab2BBX0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:26:17 -0500
Date: Thu, 2 Feb 2012 15:26:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch cr 0/4] [patch cr 0/@total@]
Message-Id: <20120202152615.be98d338.akpm@linux-foundation.org>
In-Reply-To: <20120130140905.441199885@openvz.org>
References: <20120130140905.441199885@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 18:09:05 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> Hi,
> 
> this is a series where I tried to resolve all concerns and nits
> I've got from previous attempt:
> 
>  - fs, proc: Introduce /proc/<pid>/task/<tid>/children entry v9
> 	Now everything is under CONFIG_CHECKPOINT_RESTORE
> 
>  - syscalls, x86: Add __NR_kcmp syscall v7
> 	* EBADF returned if there is no file
> 	* EOPNOTSUP returned if there is no sysv support compiled in
> 	* test uses syscall() from libc instead of own syscall implementation
> 	* man page for this syscall is under progress still
> 
>  - c/r: procfs: add arg_start/end, env_start/end and exit_code members to /proc/$pid/stat
> 	task->exit_code is shown IIF a caller has enough permissions
> 
>  - c/r: prctl: Extend PR_SET_MM to set up more mm_struct entries
> 	when restoring mm->saved_auxv the task_lock is used to serialize access
> 
> Please review, if there is something I'm still missing, ping me back.
> 

Looks pretty close to me.  I had a few issues and niggles.  Please cc
me on v10 and unless someone squawks convincingly I will grab it.

