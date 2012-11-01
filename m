Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab2KAALa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 20:11:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab2KAAL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 20:11:29 -0400
Date: Wed, 31 Oct 2012 17:11:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Will Drewry <wad@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] proc: add "Seccomp" to status
Message-Id: <20121031171127.7afe9294.akpm@linux-foundation.org>
In-Reply-To: <20121031200926.GA22988@www.outflux.net>
References: <20121031200926.GA22988@www.outflux.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012 13:09:27 -0700
Kees Cook <keescook@chromium.org> wrote:

> Adds the seccomp mode to the /proc/$pid/status file so the state of
> seccomp can be externally examined.

There's no reason here for anyone to apply this patch to anything. 
Presumably you see some value to our users - please share your thoughts
with us ;)

> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -327,6 +327,13 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
>  	render_cap_t(m, "CapBnd:\t", &cap_bset);
>  }
>  
> +static inline void task_seccomp(struct seq_file *m, struct task_struct *p)
> +{
> +#ifdef CONFIG_SECCOMP

hm, OK, cpuset_task_status_allowed() is a no-op if CONFIG_CPUSETS=n, so
there is precedent for fields vanishing with Kconfig changes.

> +	seq_printf(m, "Seccomp:\t%d\n", p->seccomp.mode);

Get thee yon unto Documentation/filesystems/proc.txt!

> +#endif
> +}

