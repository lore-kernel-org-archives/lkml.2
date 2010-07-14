Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab0GNATR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:19:17 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55560 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab0GNATP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:19:15 -0400
Message-Id: <201007140019.o6E0J9gQ060582@www262.sakura.ne.jp>
Subject: Re: [PATCH] Yama: turn process ancestry check into function
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: kees.cook@canonical.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Jul 2010 09:19:09 +0900
References: <20100713173339.GA6104@outflux.net>
In-Reply-To: <20100713173339.GA6104@outflux.net>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 13072010 #3974091, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> +static int task_is_descendant(struct task_struct *parent,
> +			      struct task_struct *child)
> +{
> +	int rc = 0;
> +	struct task_struct *walker = child;
> +
> +	if (!parent || !child)
> +		return 0;

parent (== current) is !NULL and
child (in original code) is !NULL.
You can remove this check unless you are planning to call
this function from other places.

> +	if (mode == PTRACE_MODE_ATTACH &&
> +	    ptrace_scope &&
> +	    !task_is_descendant(current, child) &&
> +	    !capable(CAP_SYS_PTRACE))
> +		rc = -EPERM;

I don't know how heavy capable(CAP_SYS_PTRACE) is.
But checking !capable(CAP_SYS_PTRACE) before
!task_is_descendant(current, child) might be lighter.
