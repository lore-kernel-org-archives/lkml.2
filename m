Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab1AEKUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 05:20:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:58589 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab1AEKUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 05:20:46 -0500
Subject: Re: [PATCH] sched: fix struct autogroup memory leak
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1294222285.8369.2.camel@marge.simson.net>
References: <1294222285.8369.2.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 11:21:14 +0100
Message-ID: <1294222874.2016.231.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 11:11 +0100, Mike Galbraith wrote:

>  static inline void autogroup_free(struct task_group *tg)
>  {
> -	kfree(tg->autogroup);
> +	if (tg->autogroup)
> +		kfree(tg->autogroup);
>  }

WARNING: kfree(NULL) is safe this check is probably not required
#43: FILE: kernel/sched_autogroup.c:24:
+       if (tg->autogroup)
+               kfree(tg->autogroup);
