Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab0KLKxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:53:49 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59498 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab0KLKxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:53:47 -0500
Subject: Re: [tg_shares_up rewrite v3 09/11] sched: demand based
 update_cfs_load()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Karl Rister <kmr@us.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
In-Reply-To: <20101112032702.028843817@google.com>
References: <20101112032405.657789056@google.com>
	 <20101112032702.028843817@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 12 Nov 2010 11:53:18 +0100
Message-ID: <1289559198.2084.214.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 19:24 -0800, Paul Turner wrote:
> +#ifdef CONFIG_FAIR_GROUP_SCHED
> +       cfs_rq->load_unacc_exec_time += delta_exec;
> +       if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window)
> {
> +               update_cfs_load(cfs_rq);
> +               update_cfs_shares(cfs_rq, 0);

Why not:
+		cfs_rq->load_unacc_exec_time -= sysctl_sched_shares_window;

(although you probably want to read the sysctl value into a local
variable using ACCESS_ONCE() and use that for both cases).

> +       }
> +#endif
>  }
>  
>  static void update_curr(struct cfs_rq *cfs_rq)
> @@ -713,6 +724,7 @@ static void update_cfs_load(struct cfs_r
>         }
>  
>         cfs_rq->load_stamp = now;
> +       cfs_rq->load_unacc_exec_time = 0; 

and drop this one?
