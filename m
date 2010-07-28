Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab0G1V1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:27:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755530Ab0G1V1L convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:27:11 -0400
MIME-Version: 1.0
In-Reply-To: <20100728211725.GF5394@nowhere>
References: <1280349590-27754-1-git-send-email-jason.wessel@windriver.com> 
	<20100728211725.GF5394@nowhere>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Jul 2010 14:26:06 -0700
Message-ID: <AANLkTikXGm0WK+N=YMWJc+hBgVAyLc0adu4K1iX5UMW=@mail.gmail.com>
Subject: Re: [GIT PULL] kgdb regression fixes for 2.6.35-rc5
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 2:17 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
> I'm sorry I spot it a bit late.
> There is a little issue in this patch, irqs won't
> be restored:
>
> @@ -588,9 +588,10 @@ int kgdb_ll_trap(int cmd, const char *str,
>        if (!kgdb_io_module_registered)
>                return NOTIFY_DONE;
>
> +       local_irq_save(flags);
>        return __kgdb_notify(&args, cmd);
> +       local_irq_restore(flags);
>  }

Yeah, that's obviously crap. I also wonder why __kgdb_notify messes up
the flags to begin with.

             Linus
