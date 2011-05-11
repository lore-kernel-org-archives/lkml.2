Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1EKQVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:21:43 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63197 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1EKQVj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:21:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bRRJQ0z/fTahD8iz1kzA2SzeRCH3wxM/kkFd544pGBy+fePhsm/wG62oLsvjCF6srL
         e3D67bYRc0i41GC+WcpT0MYJYmVo+0mAeQukTv23utYDvOiz1wX9uwsbBX7YamnUzu6Q
         dZ6CxlOXAz7l5O9BfIvt9zxjVIWKiD02GFb0g=
MIME-Version: 1.0
In-Reply-To: <20110426194904.GC8520@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
 <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
 <20110423175901.GA484@redhat.com> <20110426194822.GA8520@redhat.com> <20110426194904.GC8520@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 11 May 2011 12:21:18 -0400
Message-ID: <BANLkTikhJkFtJUwUJ3stT=juKKuo+6xT7g@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] signal: introduce do_sigtimedwait() to factor out
 compat/native code
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 15:49, Oleg Nesterov wrote:
> --- sigprocmask/include/linux/signal.h~2_do_sigtimedwait        2011-04-26 19:52:30.000000000 +0200
> +++ sigprocmask/include/linux/signal.h  2011-04-26 19:53:42.000000000 +0200
> @@ -242,6 +242,8 @@ extern int __group_send_sig_info(int, st
>  extern long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig,
>                                 siginfo_t *info);
>  extern long do_sigpending(void __user *, unsigned long);
> +extern int do_sigtimedwait(const sigset_t *, siginfo_t *,
> +                               const struct timespec *);
>  extern int sigprocmask(int, sigset_t *, sigset_t *);
>  extern void set_current_blocked(const sigset_t *);
>  extern int show_unhandled_signals;

this causes a build warning:
In file included from arch/blackfin/kernel/signal.c:8:
include/linux/signal.h:246: warning: 'struct timespec' declared inside
parameter list
include/linux/signal.h:246: warning: its scope is only this definition
or declaration, which is probably not what you want
-mike
