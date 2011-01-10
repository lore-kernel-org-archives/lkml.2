Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab1AJJQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 04:16:29 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41282 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab1AJJQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 04:16:27 -0500
Date: Mon, 10 Jan 2011 14:46:22 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: autogroup: sched_setscheduler() fails
Message-ID: <20110110091622.GF2772@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With autogroup ON, sched_setscheduler() fails when I try to change the
scheduling policy of a normal task to either RR or FIFO.

sched_setscheduler() returns -EPERM when it finds that the group doesn't
have any rt bandwidth. This is expected because with autogroup, the task
is in an autogroup for which task_group(p)->rt_bandwidth.rt_runtime is 0.

I guess the task needs to be moved to appropriate cgroup (from its current
autogroup) when such policy change is requested, but I wasn't sure if
group change from sched_setscheduler() can be achieved easily.

Regards,
Bharata.
