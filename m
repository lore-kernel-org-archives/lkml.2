Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591Ab1ESQd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:33:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933481Ab1ESQdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:33:53 -0400
Date: Thu, 19 May 2011 18:32:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 09/10] ptrace: add JOBCTL_BLOCK_NOTIFY
Message-ID: <20110519163233.GE17265@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305569849-10448-10-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Tejun Heo wrote:
>
> +static void ptrace_put_task_struct(struct task_struct *child)
> +{
> +	unsigned long flags;
> +
> +	if (!(child->jobctl & JOBCTL_BLOCK_NOTIFY))
> +		goto out_put;
> +
> +	if (unlikely(!lock_task_sighand(child, &flags)))
> +		goto out_put;
> +
> +	/*
> +	 * Make sure @chlid is still ptraced by us and clear BLOCK_NOTIFY.
> +	 */
> +	if (likely((child->ptrace & PT_PTRACED) && child->parent == current))

This looks a bit confusing... It is either traced or not. If it is traced,
nobody else can trace it. In fact even PT_PTRACED is not strictly needed
but I agree this check makes the code cleaner.

Oleg.

