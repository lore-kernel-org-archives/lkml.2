Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab1AEREN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:04:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:35802 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab1AEREM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:04:12 -0500
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <1294246647.8369.52.camel@marge.simson.net>
References: <20110103162637.29f23c40@annuminas.surriel.com>
	 <20110103162918.577a9620@annuminas.surriel.com>
	 <1294164289.2016.186.camel@laptop>
	 <1294246647.8369.52.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 18:04:25 +0100
Message-ID: <1294247065.2016.267.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 17:57 +0100, Mike Galbraith wrote:
> +               p_cfs_rq = cfs_rq_of(pse);
> +               local = 1;
> +       }
> +#endif
> +
> +       /* Tell the scheduler that we'd really like pse to run next. */
> +       p_cfs_rq->next = pse;
> +
> +       /* We know whether we want to preempt or not, but are we allowed? */
> +       preempt &= same_thread_group(p, task_of(p_cfs_rq->curr));
> +
> +       if (local)
> +               clear_buddies(cfs_rq, se); 

You might want to clear before setting next :-)
