Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab2KZTDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:03:11 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36772 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2KZTDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:03:09 -0500
From: Benjamin Segall <bsegall@google.com>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, pjt@google.com,
        preeti@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] enable runnable load avg in load balance
References: <1353157457-3649-1-git-send-email-alex.shi@intel.com>
Date: Mon, 26 Nov 2012 11:03:05 -0800
In-Reply-To: <1353157457-3649-1-git-send-email-alex.shi@intel.com> (Alex Shi's
	message of "Sat, 17 Nov 2012 21:04:12 +0800")
Message-ID: <xm26ehjg5gra.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, I've been trying out using the runnable averages for load balance in
a few ways, but haven't actually gotten any improvement on the
benchmarks I've run. I'll post my patches once I have the numbers down,
but it's generally been about half a percent to 1% worse on the tests
I've tried.

The basic idea is to use (cfs_rq->runnable_load_avg +
cfs_rq->blocked_load_avg) (which should be equivalent to doing
load_avg_contrib on the rq) for cfs_rqs and possibly the rq, and
p->se.load.weight * p->se.avg.runnable_avg_sum / period for tasks.

I have not yet tried including wake_affine, so this has just involved
h_load (task_load_down and task_h_load), as that makes everything
(besides wake_affine) be based on either the new averages or the
rq->cpu_load averages.
