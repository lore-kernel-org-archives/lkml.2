Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab1LVBRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:17:45 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:53498 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab1LVBRn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:17:43 -0500
MIME-Version: 1.0
In-Reply-To: <20111221111143.620776435@chello.nl>
References: <20111221105739.798864333@chello.nl> <20111221111143.620776435@chello.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 21 Dec 2011 17:17:21 -0800
X-Google-Sender-Auth: 01oGUpKSQjmlOh7XzFIDWXKJNbY
Message-ID: <CA+55aFw_rQbOho8WojeiD3YZtzud99CAXZCzqoKNF1HRGXgnZA@mail.gmail.com>
Subject: Re: [RFC][PATCH 6/7] printk: Poke printk extra hard
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Ted Ts'o" <tytso@mit.edu>, Greg KH <greg@kroah.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 2:57 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>
> +#ifdef CONFIG_PRINTK_DEBUG
> +void printk_init(void)
> +{
> +       struct rq *rq;
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +       rq = this_rq();
> +       raw_spin_lock(&rq->lock);
> +       printk(KERN_DEBUG "printk: echo echo echo..\n");
> +       raw_spin_unlock(&rq->lock);
> +       local_irq_restore(flags);

Ok, I can't really say that I think this is worth a config option like this.

Maybe an example module or something?

And I don't know *why*, but my immediate reaction to the message was
that it either should be serious and say what it tested ("printk()
works under rq lock"), or it should say "Bork bork bork". "echo echo
echo" sounds just stupid.

                 Linus
