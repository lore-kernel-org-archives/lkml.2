Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab2K0BNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 20:13:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:44553 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757691Ab2K0BNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 20:13:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,323,1352102400"; 
   d="scan'208";a="252939636"
Message-ID: <50B41346.3030606@intel.com>
Date: Tue, 27 Nov 2012 09:11:34 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Benjamin Segall <bsegall@google.com>
CC: mingo@redhat.com, peterz@infradead.org, pjt@google.com,
        preeti@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] enable runnable load avg in load balance
References: <1353157457-3649-1-git-send-email-alex.shi@intel.com> <xm26ehjg5gra.fsf@sword-of-the-dawn.mtv.corp.google.com>
In-Reply-To: <xm26ehjg5gra.fsf@sword-of-the-dawn.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 03:03 AM, Benjamin Segall wrote:
> So, I've been trying out using the runnable averages for load balance in
> a few ways, but haven't actually gotten any improvement on the
> benchmarks I've run. I'll post my patches once I have the numbers down,
> but it's generally been about half a percent to 1% worse on the tests
> I've tried.

Did you tried this rfc patch? and what's the result of it? :)

> 
> The basic idea is to use (cfs_rq->runnable_load_avg +
> cfs_rq->blocked_load_avg) (which should be equivalent to doing
> load_avg_contrib on the rq) for cfs_rqs and possibly the rq, and
> p->se.load.weight * p->se.avg.runnable_avg_sum / period for tasks.
> 
> I have not yet tried including wake_affine, so this has just involved
> h_load (task_load_down and task_h_load), as that makes everything
> (besides wake_affine) be based on either the new averages or the
> rq->cpu_load averages.
> 

