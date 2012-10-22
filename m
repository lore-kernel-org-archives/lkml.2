Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab2JVVy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:54:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52580 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab2JVVyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:54:54 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1210202133470.2719@ionos>
References: <alpine.LFD.2.02.1210202133470.2719@ionos>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Mon, 22 Oct 2012 17:54:24 -0400
X-Google-Sender-Auth: S7tI-1doSKrcqkE7KhqCAXXb9Ys
Message-ID: <CAP=VYLr9c13w+CWTDUfgT2dFbmXTBUfBWrJ43u731q9weBmjSg@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.6.2-rt4
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 3:40 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Dear RT Folks,
>
> I'm pleased to announce the 3.6.2-rt4 release. rt4 is just an update
> to 3.6.2. The not announced 3.6.1-rt3 is an intermediate release with
> a single change.

I've updated the repo of patches to have rt3 and rt4 on master branch.

In my fixes branch (now v3.6.2-rt4-fixes) there is only the cosmetic fix
of adding a subject to the power-use-generic-rwsem-on-rt.patch,
everything else is in the main tarballs.

There is a gregkh v3.6.3 release - the series applies onto that with
only a trivial patch refresh required to kgb-serial-hackaround.patch

In fact, quilt may not even bother to warn about it, but git-am will
stop and ask you to double check things.  If git-am still fails when
we get to v3.6.3-rt5, then I'll refresh it on the -fixes branch.

http://git.kernel.org/?p=linux/kernel/git/paulg/3.6-rt-patches.git;a=summary

Paul.
--

>
> Changes since 3.6.1-rt2:
>
>         * Remove the softirq noise printk
>
> The delta patch against 3.6.1-rt2 is appended below and can be found here
>
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.1-rt2-rt3.patch.xz
>
> The RT patch against 3.6.2 can be found here:
>
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.2-rt4.patch.xz
>
> The split quilt queue is available at:
>
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.2-rt4.tar.xz
>
> Enjoy,
>
>         tglx
>
> ---------->
>
> Index: linux-stable/kernel/softirq.c
> ===================================================================
> --- linux-stable.orig/kernel/softirq.c
> +++ linux-stable/kernel/softirq.c
> @@ -468,8 +468,6 @@ static void do_single_softirq(int which,
>   */
>  static void do_current_softirqs(int need_rcu_bh_qs)
>  {
> -       int retry = 0;
> -
>         while (current->softirqs_raised) {
>                 int i = __ffs(current->softirqs_raised);
>                 unsigned int pending, mask = (1U << i);
> @@ -496,10 +494,6 @@ static void do_current_softirqs(int need
>                 }
>                 unlock_softirq(i);
>                 WARN_ON(current->softirq_nestcnt != 1);
> -               if (++retry == 20) {
> -                       printk(KERN_ERR "Crap, %s looping forever in softirq\n",
> -                              current->comm);
> -               }
>         }
>  }
>
> Index: linux-stable/localversion-rt
> ===================================================================
> --- linux-stable.orig/localversion-rt
> +++ linux-stable/localversion-rt
> @@ -1 +1 @@
> --rt2
> +-rt3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
