Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab0CYXce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 19:32:34 -0400
Received: from ozlabs.org ([203.10.76.45]:47146 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab0CYXcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 19:32:33 -0400
Date: Fri, 26 Mar 2010 10:30:31 +1100
From: Anton Blanchard <anton@samba.org>
To: Amit Shah <amit.shah@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, tglx@linutronix.de, mingo@elte.hu,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH 4/7] hvc_console: Fix race between hvc_close and
 hvc_remove
Message-ID: <20100325233031.GC5594@kryten>
References: <20100319151326.GC8541@kroah.com>
 <1269011916-8836-4-git-send-email-gregkh@suse.de>
 <1269119079.8599.65.camel@pasglop>
 <20100321043725.GA21566@amit-x200.redhat.com>
 <20100324121902.GJ15789@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324121902.GJ15789@amit-x200.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi,

> And this suggests that hvc_kick() is called before hvc_task is
> initialised, ie, before hvc_init() is called.
>
> Does this help?

Looks good, tests OK on my POWER5 box. Thanks!

Tested-by: Anton Blanchard <anton@samba.org>

> diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
> index ba55bba..50ac983 100644
> --- a/drivers/char/hvc_console.c
> +++ b/drivers/char/hvc_console.c
> @@ -285,6 +285,9 @@ EXPORT_SYMBOL_GPL(hvc_instantiate);
>  /* Wake the sleeping khvcd */
>  void hvc_kick(void)
>  {
> +       if (!hvc_task)
> +               return;
> +
>         hvc_kicked = 1;
>         wake_up_process(hvc_task);
>  }
> 
> 		Amit
