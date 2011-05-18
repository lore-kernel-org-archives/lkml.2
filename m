Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab1ERXiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:38:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756170Ab1ERXiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:38:03 -0400
Date: Wed, 18 May 2011 16:37:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] signal: trivial, fix the
 "timespec declared inside parameter list" warning
Message-Id: <20110518163725.13e816fe.akpm@linux-foundation.org>
In-Reply-To: <20110516125728.GB7941@redhat.com>
References: <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
	<20110418173224.GA27918@redhat.com>
	<BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
	<20110423175901.GA484@redhat.com>
	<20110426194822.GA8520@redhat.com>
	<20110426194904.GC8520@redhat.com>
	<BANLkTikhJkFtJUwUJ3stT=juKKuo+6xT7g@mail.gmail.com>
	<20110513164435.GA22435@redhat.com>
	<BANLkTimGjunaA4Fzdo6dc5=cKTc_g90j5Q@mail.gmail.com>
	<20110516125702.GA7941@redhat.com>
	<20110516125728.GB7941@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2011 14:57:29 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Fix the compile warning, do_sigtimedwait(struct timespec *) in signal.h
> needs the forward declaration of timespec.
> 

The offending patch is in your tree, so you may as well put this patch
in there too.

> --- sigprocmask/include/linux/signal.h~15_stw_warning	2011-05-12 20:44:43.000000000 +0200
> +++ sigprocmask/include/linux/signal.h	2011-05-16 14:53:08.000000000 +0200
> @@ -234,6 +234,9 @@ static inline int valid_signal(unsigned 
>  	return sig <= _NSIG ? 1 : 0;
>  }
>  
> +struct timespec;
> +struct pt_regs;
> +
>  extern int next_signal(struct sigpending *pending, sigset_t *mask);
>  extern int do_send_sig_info(int sig, struct siginfo *info,
>  				struct task_struct *p, bool group);

Please put the forward declarations at top-of-file.  In this case,
inside #ifdef __KERNEL__.  This reduces the risk of accumulating
duplicated forward declarations, as has happened in the past.



