Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab0KMTUl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 14:20:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:56006 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192Ab0KMTUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 14:20:38 -0500
Subject: Re: [RFC][PATCH v2 1/7] taskstats: Add new taskstats command
 TASKSTATS_CMD_ATTR_PIDS
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <20101111170813.527389224@linux.vnet.ibm.com>
References: <20101111170352.732381138@linux.vnet.ibm.com>
	 <20101111170813.527389224@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Nov 2010 20:20:05 +0100
Message-ID: <1289676005.2109.148.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 18:03 +0100, Michael Holzheu wrote:
> As clock for 'now' and 'time' the sched_clock() function is used and the patch

> +       preempt_disable();
> +       stats->time_ns = sched_clock();
> +       preempt_enable();

> +       task_snap_time = sched_clock();

That's just plain broken...



> +       t->sched_info.last_depart = task_rq(t)->clock;

Are you sure you don't mean task_rq(t)->clock_task ? 



