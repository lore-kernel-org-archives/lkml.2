Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2IGPj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:39:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:37350 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab2IGPjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:39:20 -0400
Message-ID: <1347032350.18408.88.camel@twins>
Subject: Re: [PATCH 1/3] perf: use hrtimer for event multiplexing
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com, robert.richter@amd.com
Date: Fri, 07 Sep 2012 17:39:10 +0200
In-Reply-To: <1347028169-1983-2-git-send-email-eranian@google.com>
References: <1347028169-1983-1-git-send-email-eranian@google.com>
	 <1347028169-1983-2-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 16:29 +0200, Stephane Eranian wrote:
> @@ -148,6 +148,15 @@ static LIST_HEAD(pmus);
>  static DEFINE_MUTEX(pmus_lock);
>  static struct srcu_struct pmus_srcu;
>  
> +struct perf_cpu_hrtimer {
> +       struct hrtimer hrtimer;
> +       int active;
> +};
> +
> +static DEFINE_PER_CPU(struct list_head, rotation_list);
> +
> +static DEFINE_PER_CPU(struct perf_cpu_hrtimer, perf_cpu_hrtimer);


How about sticking the hrtimer in perf_cpu_context so you can have a
different rotation interval per PMU ?

Sorta like e9d2b064149ff7ef4acbc65a1b9374ac8b218d3e removed. Stopping
the timer when the PMU isn't over committed should solve the NOHZ
problem I think.
