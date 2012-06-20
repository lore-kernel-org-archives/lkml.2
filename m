Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab2FTRk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:40:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:35827 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab2FTRky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:40:54 -0400
Message-ID: <1340214048.21745.124.camel@twins>
Subject: Re: [PATCH v3] sched: balance_cpu to consider other cpus in its
 group as target of (pinned) task
From: Peter Zijlstra <peterz@infradead.org>
To: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Cc: mingo@kernel.org, LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, efault@gmx.de,
        Ingo Molnar <mingo@elte.hu>
Date: Wed, 20 Jun 2012 19:40:48 +0200
In-Reply-To: <4FE06CDB.2060605@linux.vnet.ibm.com>
References: <4FE06CDB.2060605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 17:43 +0530, Prashanth Nageshappa wrote:
> +               new_dst_cpu = cpumask_first_and(env->dst_grpmask,
> +                                               tsk_cpus_allowed(p));


> +               if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0 &&
> +                               lb_iterations++ < max_lb_iterations) { 

Hmm, too bad dst_grpmask isn't an actual mask, otherwise we could simply
clear the cpu we just had, just like the ALL_PINNED does with cpus.
