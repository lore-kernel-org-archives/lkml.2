Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab1HTEBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 00:01:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40977 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab1HTEBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 00:01:21 -0400
MIME-Version: 1.0
In-Reply-To: <1313772419-21951-8-git-send-email-matt@console-pimps.org>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org> <1313772419-21951-8-git-send-email-matt@console-pimps.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sat, 20 Aug 2011 00:00:59 -0400
X-Google-Sender-Auth: vuhjd7IRS9Cj-o6nGsoP5n9gPTs
Message-ID: <CAMjpGUcwkLkHo33WY1vJr4pWPz9wgVcwti5nuqLM2FQYWn6O=A@mail.gmail.com>
Subject: Re: [PATCH v2 07/43] blackfin: Use set_current_blocked() and block_sigmask()
To: Matt Fleming <matt@console-pimps.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 12:46, Matt Fleming wrote:
> --- a/arch/blackfin/kernel/signal.c
> +++ b/arch/blackfin/kernel/signal.c
> -       if (ret == 0) {
> -               spin_lock_irq(&current->sighand->siglock);
> -               sigorsets(&current->blocked, &current->blocked,
> -                         &ka->sa.sa_mask);
> -               if (!(ka->sa.sa_flags & SA_NODEFER))
> -                       sigaddset(&current->blocked, sig);
> -               recalc_sigpending();
> -               spin_unlock_irq(&current->sighand->siglock);
> -       }
> +       if (ret == 0)
> +               block_sigmask(ka, sig);

the Blackfin version holds siglock and calls recalc_sigpending() while
block_sigmask() does neither.  i'm guessing that is expected behavior
now ?
-mike
