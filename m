Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab0ETUur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 16:50:47 -0400
Received: from www.tglx.de ([62.245.132.106]:52209 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab0ETUuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 16:50:46 -0400
Date: Thu, 20 May 2010 22:46:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Emelyanov <xemul@openvz.org>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH 2/3] posix_timer: fix error path in timer_create
In-Reply-To: <20100520123155.c4b7a1ed.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1005202246140.3368@localhost.localdomain>
References: <1274116688-4037-1-git-send-email-avagin@openvz.org> <1274116688-4037-2-git-send-email-avagin@openvz.org> <20100520123155.c4b7a1ed.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010, Andrew Morton wrote:

> On Mon, 17 May 2010 21:18:07 +0400
> Andrey Vagin <avagin@openvz.org> wrote:
> 
> > move CLOCK_DISPATCH(which_clock, timer_create, (new_timer)) after all
> > posible EFAULT erros.
> > 
> > *_timer_create may allocate/get resources.
> > (for example posix_cpu_timer_create does get_task_struct)
> > 
> 
> You've added a Cc:stable@kernel.org to the mail headers, but there is
> no "Cc: <stable@kernel.org>" in the changelog.  Please, if you think a
> patch should go into -stable then add the tag to the changelog also -
> this is more reliable and explicit than spraying things at a mailing
> list.
> 
> You cc'ed stable@kernel.org on all three patches but IMO only [2/3]
> (this patch) is needed in -stable.
> 
> And afaict, the bug which this patch fixes will allow a suitably-nasty
> unprivileged application to leak an unbounded number of task-structs,
> which is a box-killing local DoS.  So yes, -stable wants this.

I'm adding it to 2/3 only. Have that lot queued up already.

Thanks,

	tglx

