Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab2LMQ0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:26:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab2LMQ0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:26:50 -0500
Date: Thu, 13 Dec 2012 17:27:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/tile: provide PT_FLAGS_COMPAT value in pt_regs
Message-ID: <20121213162710.GA20271@redhat.com>
References: <201212122227.qBCMRiNg000851@farm-0002.internal.tilera.com> <20121212234307.GA7694@redhat.com> <50C9ECFF.6070708@tilera.com> <20121213154929.GA17421@redhat.com> <50C9FF11.2030303@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C9FF11.2030303@tilera.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13, Chris Metcalf wrote:
>
> On 12/13/2012 10:49 AM, Oleg Nesterov wrote:
> > But ptrace_setoptions() returns EINVAL? it doesn't accept illegal bits.
>
> It does return EINVAL - but if it gets both legal and illegal bits,
> it honors all the legal bits first.

This was true in the past, but now we have

	static int ptrace_setoptions(struct task_struct *child, unsigned long data)
	{
		unsigned flags;

		if (data & ~(unsigned long)PTRACE_O_MASK)
			return -EINVAL;

		/* Avoid intermediate state when all opts are cleared */
		flags = child->ptrace;
		flags &= ~(PTRACE_O_MASK << PT_OPT_FLAG_SHIFT);
		flags |= (data << PT_OPT_FLAG_SHIFT);
		child->ptrace = flags;

		return 0;
	}

> > So I'd say it looks fine to me.
>
> Thanks!  Should I convert that to a Reviewed-by or Acked-by on the patch?

Heh ;) Please feel free to add Acked-by: Oleg Nesterov <oleg@redhat.com>

Oleg.

