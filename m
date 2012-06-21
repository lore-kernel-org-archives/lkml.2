Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab2FUEYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 00:24:06 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:51505 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2FUEYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 00:24:04 -0400
Date: Thu, 21 Jun 2012 09:53:47 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org, efault@gmx.de,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3] sched: balance_cpu to consider other cpus in its
 group as target of (pinned) task
Message-ID: <20120621042347.GA5059@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <4FE06CDB.2060605@linux.vnet.ibm.com>
 <1340213901.21745.122.camel@twins>
 <20120621034059.GA9748@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120621034059.GA9748@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12062104-5564-0000-0000-0000034746C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> [2012-06-21 09:10:59]:

> Hmm ..I can see loop_break being incremented here:
> 
>                 /* take a breather every nr_migrate tasks */
>                 if (env->loop > env->loop_break) {
>                         env->loop_break += sched_nr_migrate_break;

One possibility is to reset env->loop here, rather than loop_break, in
which case loop_break can remain constant across "redos" and
"more_balances"


>                         env->flags |= LBF_NEED_BREAK;
>                         goto out;
>                 }

- vatsa

