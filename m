Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603Ab1EMQpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:45:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759198Ab1EMQpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:45:50 -0400
Date: Fri, 13 May 2011 18:44:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] signal: trivial, fix the "timespec declared inside
	parameter list" warning
Message-ID: <20110513164435.GA22435@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com> <20110426194822.GA8520@redhat.com> <20110426194904.GC8520@redhat.com> <BANLkTikhJkFtJUwUJ3stT=juKKuo+6xT7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikhJkFtJUwUJ3stT=juKKuo+6xT7g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the compile warning, do_sigtimedwait(struct timespec *) in signal.h
needs the forward declaration of timespec.

Reported-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/signal.h |    1 +
 1 file changed, 1 insertion(+)

--- sigprocmask/include/linux/signal.h~15_stw_warning	2011-05-12 20:44:43.000000000 +0200
+++ sigprocmask/include/linux/signal.h	2011-05-13 18:10:40.000000000 +0200
@@ -242,6 +242,7 @@ extern int __group_send_sig_info(int, st
 extern long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig,
 				 siginfo_t *info);
 extern long do_sigpending(void __user *, unsigned long);
+struct timespec;
 extern int do_sigtimedwait(const sigset_t *, siginfo_t *,
 				const struct timespec *);
 extern int sigprocmask(int, sigset_t *, sigset_t *);

