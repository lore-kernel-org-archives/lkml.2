Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab1EPM6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:58:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab1EPM6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:58:45 -0400
Date: Mon, 16 May 2011 14:57:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] signal: trivial, fix the "timespec declared inside
	parameter list" warning
Message-ID: <20110516125728.GB7941@redhat.com>
References: <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com> <20110426194822.GA8520@redhat.com> <20110426194904.GC8520@redhat.com> <BANLkTikhJkFtJUwUJ3stT=juKKuo+6xT7g@mail.gmail.com> <20110513164435.GA22435@redhat.com> <BANLkTimGjunaA4Fzdo6dc5=cKTc_g90j5Q@mail.gmail.com> <20110516125702.GA7941@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516125702.GA7941@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the compile warning, do_sigtimedwait(struct timespec *) in signal.h
needs the forward declaration of timespec.

Reported-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/signal.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- sigprocmask/include/linux/signal.h~15_stw_warning	2011-05-12 20:44:43.000000000 +0200
+++ sigprocmask/include/linux/signal.h	2011-05-16 14:53:08.000000000 +0200
@@ -234,6 +234,9 @@ static inline int valid_signal(unsigned 
 	return sig <= _NSIG ? 1 : 0;
 }
 
+struct timespec;
+struct pt_regs;
+
 extern int next_signal(struct sigpending *pending, sigset_t *mask);
 extern int do_send_sig_info(int sig, struct siginfo *info,
 				struct task_struct *p, bool group);
@@ -248,7 +251,6 @@ extern int sigprocmask(int, sigset_t *, 
 extern void set_current_blocked(const sigset_t *);
 extern int show_unhandled_signals;
 
-struct pt_regs;
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
 extern void exit_signals(struct task_struct *tsk);
 

