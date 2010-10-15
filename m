Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0JOMIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:08:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:58273 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab0JOMIf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:08:35 -0400
Subject: Re: [PATCH 4/4] sched: force balancing on newidle balance if local
 group has capacity
From: Peter Zijlstra <peterz@infradead.org>
To: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1286996978-7007-5-git-send-email-ncrao@google.com>
References: <1286996978-7007-1-git-send-email-ncrao@google.com>
	 <1286996978-7007-5-git-send-email-ncrao@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 14:08:02 +0200
Message-ID: <1287144482.29097.1463.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 12:09 -0700, Nikhil Rao wrote:
> @@ -2824,6 +2845,10 @@ find_busiest_group(struct sched_domain *sd, int
> this_cpu,
>         if (!sds.busiest || sds.busiest_nr_running == 0)
>                 goto out_balanced;
>  
> +       /*  SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
> +       if (idle == CPU_NEWLY_IDLE && check_utilization(&sds))
> +               goto force_balance;


There's a large comment a few lines up from here that tries to explain
all these funny reasons for not balancing, that wants updating too.


