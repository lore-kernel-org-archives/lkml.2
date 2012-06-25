Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab2FYLjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 07:39:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51540 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2FYLjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 07:39:42 -0400
Subject: Re: Question about the export of symbol lockdep_init_map
From: Peter Zijlstra <peterz@infradead.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4FE7512D.2010608@lwfinger.net>
References: <4FE7512D.2010608@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jun 2012 13:39:28 +0200
Message-ID: <1340624368.2507.53.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-06-24 at 12:41 -0500, Larry Finger wrote:
> Ingo,
> 
> when you added the locking correctness validator code in commit fbb9ce95, you 
> exported lockdep_init_map() with EXPORT_SYMBOL_GPL. This choice is causing a 
> problem with the latest version of Broadcom's hybrid wl driver. Although I do 
> not agree with their policies regarding drivers with binary blobs, there are 
> some devices such as the BCM43228 (14e4:4359) for which no open-source driver is 
> yet available. As a result, owners of such devices are forced to use solutions 
> such as ndiswrapper, which is worse than using wl.
> 
> would you accept the following patch?
> 
> Index: wireless-testing/kernel/lockdep.c
> ===================================================================
> --- wireless-testing.orig/kernel/lockdep.c
> +++ wireless-testing/kernel/lockdep.c
> @@ -2994,7 +2994,7 @@ void lockdep_init_map(struct lockdep_map
>          if (subclass)
>                  register_lock_class(lock, subclass, 1);
>   }
> -EXPORT_SYMBOL_GPL(lockdep_init_map);
> +EXPORT_SYMBOL(lockdep_init_map);
> 
>   struct lock_class_key __lockdep_no_validate__;
> 

I can't speak for Ingo, but I would object to it. Owners of such devices
can send them back to wherever they got them from and demand a refund.

Loading binary blobs pretty much wrecks your kernel validation anyway,
who knows what they do.

