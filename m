Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab1EMSJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:09:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54657 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1EMSJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IZMmBtfLZ/01Jarpjwbjn5/VMiw3w5aEpnAwIbo3dGIaK8VpmkFza8/gtQJJKzdkw9
         0WasJ0Hb80Y3ALadRliKOaOM/tVa0Kkp0EIXdqafs7uK+bm8+WRswnPlcvCHncvhjEk9
         8SNGbvqKIHjz0y67ldW8jI8sB5ETZGmblz5qs=
MIME-Version: 1.0
In-Reply-To: <20110513164435.GA22435@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
 <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
 <20110423175901.GA484@redhat.com> <20110426194822.GA8520@redhat.com>
 <20110426194904.GC8520@redhat.com> <BANLkTikhJkFtJUwUJ3stT=juKKuo+6xT7g@mail.gmail.com>
 <20110513164435.GA22435@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 13 May 2011 14:09:22 -0400
Message-ID: <BANLkTimGjunaA4Fzdo6dc5=cKTc_g90j5Q@mail.gmail.com>
Subject: Re: [PATCH] signal: trivial, fix the "timespec declared inside
 parameter list" warning
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

On Fri, May 13, 2011 at 12:44, Oleg Nesterov wrote:
> --- sigprocmask/include/linux/signal.h~15_stw_warning   2011-05-12 20:44:43.000000000 +0200
> +++ sigprocmask/include/linux/signal.h  2011-05-13 18:10:40.000000000 +0200
> @@ -242,6 +242,7 @@ extern int __group_send_sig_info(int, st
>  extern long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig,
>                                 siginfo_t *info);
>  extern long do_sigpending(void __user *, unsigned long);
> +struct timespec;
>  extern int do_sigtimedwait(const sigset_t *, siginfo_t *,
>                                const struct timespec *);
>  extern int sigprocmask(int, sigset_t *, sigset_t *);

seems like you'd want to stick this higher up in the file (like after
the includes or at the top of the prototype block) so that in the
future, you dont have to move it if someone adds a new func before it.
-mike
