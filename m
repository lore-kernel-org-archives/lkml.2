Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab0ENL5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 07:57:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51221 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab0ENL5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 07:57:05 -0400
Date: Fri, 14 May 2010 13:56:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Performance Events hangs with Intel P4 system
Message-ID: <20100514115655.GA18069@elte.hu>
References: <AANLkTimKHkgWJJOOICzQ4TL3mbL-lvYEocwBSe3XSBVR@mail.gmail.com>
 <AANLkTiktLXqHhop21ePIXF2kaVQbm3DIHZpLrEQOMA1e@mail.gmail.com>
 <AANLkTimCjt0R7A23xTrmToTqTcF4ZW4sNWtjMwjVIVqe@mail.gmail.com>
 <AANLkTinbrhuGqHss_aML3EAccOq792GUZtqzzjQqzG6I@mail.gmail.com>
 <AANLkTimVmlPfRFu8Wo2KL1pyF6qtTSQriawvrKcsMe9Y@mail.gmail.com>
 <AANLkTimrHGq1kZwPev7gBZu6Hqxlhe0ZscSKjEinZtcf@mail.gmail.com>
 <AANLkTik-gIjZu60pFWEhhe8MolQITrtk0wfpvSUCLnrD@mail.gmail.com>
 <AANLkTinPcjUyPyUP4L7opELEbLZy-tXxkbm-nqe8Co0f@mail.gmail.com>
 <1273834571.3530.82.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273834571.3530.82.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0594]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lin Ming <ming.m.lin@intel.com> wrote:

> p4_event_bind::cntr is "unsigned char".
> But p4_next_cntr has return type of "int".
> So the explicit conversion is needed to get the correct result. 

> @@ -780,7 +780,7 @@ static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign
>  		if (unlikely(escr_idx == -1))
>  			goto done;
>  
> -		if (hwc->idx != -1 && !p4_should_swap_ts(hwc->config, cpu)) {
> +		if (hwc->idx != (unsigned char)-1 && !p4_should_swap_ts(hwc->config, cpu)) {

That cast is _extremely_ ugly. Please fix the signedness of the types instead.

	Ingo
