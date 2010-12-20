Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab0LTPHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:07:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314Ab0LTPHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:07:16 -0500
Date: Mon, 20 Dec 2010 16:00:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 06/16] signal: fix premature completion of group stop
	when interfered by ptrace
Message-ID: <20101220150018.GD11583@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291654624-6230-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Tejun Heo wrote:
>
> +static bool task_participate_group_stop(struct task_struct *task)
> +{
> +	struct signal_struct *sig = task->signal;
> +	bool consume = task->group_stop & GROUP_STOP_CONSUME;
> +
> +	task_clear_group_stop(task);
> +
> +	if (!consume)
> +		return false;
> +
> +	task->group_stop &= ~GROUP_STOP_CONSUME;

Minor nit, GROUP_STOP_CONSUME was already cleared by task_clear_group_stop().

Oleg.

