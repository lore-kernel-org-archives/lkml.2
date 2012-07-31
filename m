Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab2GaSWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:22:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321Ab2GaSWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:22:51 -0400
Date: Tue, 31 Jul 2012 19:40:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, a.p.zijlstra@chello.nl,
        mingo@redhat.com, srikar@linux.vnet.ibm.com, roland@hack.frob.com
Subject: Re: [PATCH 1/2] uprobes: Use a helper instead of ptrace's single
	step enable
Message-ID: <20120731174024.GB14576@redhat.com>
References: <20120730141638.GA5306@redhat.com> <1343735548-18101-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343735548-18101-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Sebastian Andrzej Siewior wrote:
>
> +void __weak arch_uprobe_enable_step(struct task_struct *child,
> +		struct arch_uprobe *arch)
> +{
> +	user_enable_single_step(current);
> +}
> +
> +void __weak arch_uprobe_disable_step(struct task_struct *child,
> +		struct arch_uprobe *arch)
> +{
> +	user_disable_single_step(child);
> +}

I don't think this needs "struct task_struct *child", it is always
current "by definition". Only current can play with ->utask.

Oleg.

