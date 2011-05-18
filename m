Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522Ab1ERSkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:40:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab1ERSkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:40:06 -0400
Date: Wed, 18 May 2011 20:38:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 04/10] ptrace: implement PTRACE_INTERRUPT
Message-ID: <20110518183815.GA1064@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305569849-10448-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Tejun Heo wrote:
>
> +	case PTRACE_INTERRUPT:
> +		/*
> +		 * Stop tracee without any side-effect on signal or job
> +		 * control.  At least one trap is guaranteed to happen
> +		 * after this request.  If @child is already trapped, the
> +		 * current trap is not disturbed and another trap will
> +		 * happen after the current trap is ended with PTRACE_CONT.
> +		 *
> +		 * The actual trap might not be PTRACE_EVENT_STOP trap but
> +		 * the pending condition is cleared regardless.
> +		 */
> +		if (likely(child->ptrace & PT_SEIZED) &&
> +		    lock_task_sighand(child, &flags)) {
> +			child->jobctl |= JOBCTL_TRAP_STOP;

The same race with do_signal_stop() afaics.

Otherwise looks fine to me. Compared to V1, personally I like the new
behaviour more. PTRACE_INTERRUPT and PTRACE_SEIZE do the same.

Oleg.

