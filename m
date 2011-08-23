Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab1HWS5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:57:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32833 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab1HWS5A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:57:00 -0400
Subject: Re: [PATCH v3 2/2] sched: Handle on_list ancestor in
 list_add_leaf_cfs_rq()
From: Peter Zijlstra <peterz@infradead.org>
To: "Jan H." =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 23 Aug 2011 20:56:43 +0200
References: <1313503666-13726-1-git-send-email-schnhrr@cs.tu-berlin.de>
	 <1313503666-13726-3-git-send-email-schnhrr@cs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314125803.8002.91.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 20:53 +0200, Peter Zijlstra wrote:
>         LIST_HEAD(leaf_queue);
> 
>         for_each_sched_entity(se) {
>                 if (se->on_rq)
>                         break;
>                 cfs_rq = cfs_rq_of(se);
>                 enqueue_entity(cfs_rq, se, flags);
>                 flags = ENQUEUE_WAKEUP;
>                 if (cfs_rq->nr_running == 1)
>                         leaf_add_queue(cfs_rq, &leaf_queue);
>         }
>         /* XXX does ->on_rq imply ->on_list ? */
>         if (se->on_list)
>                 leaf_splice_queue(cfs_rq, &leaf_queue); 

Bah, se can be NULL here, still needing some extra foo.
