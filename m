Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab1EPQF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:05:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44465 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab1EPQF0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:05:26 -0400
Subject: Re: [patch 08/15] sched: throttle cfs_rq entities which exceed
 their local runtime
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
In-Reply-To: <20110503092905.163081832@google.com>
References: <20110503092846.022272244@google.com>
	 <20110503092905.163081832@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 May 2011 18:05:03 +0200
Message-ID: <1305561903.2466.4458.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 02:28 -0700, Paul Turner wrote:
> +       task_delta = -cfs_rq->h_nr_running;
> +       for_each_sched_entity(se) {
> +               struct cfs_rq *qcfs_rq = cfs_rq_of(se);
> +               /* throttled entity or throttle-on-deactivate */
> +               if (!se->on_rq)
> +                       break;
> +
> +               if (dequeue)
> +                       dequeue_entity(qcfs_rq, se, DEQUEUE_SLEEP);
> +               qcfs_rq->h_nr_running += task_delta;
> +
> +               if (qcfs_rq->load.weight)
> +                       dequeue = 0;
> +       }
> +
> +       if (!se)
> +               rq->nr_running += task_delta; 

So throttle is like dequeue, it removes tasks, so why then insist on
writing it like its adding tasks? (I see you're adding a negative
number, but its all just weird).
