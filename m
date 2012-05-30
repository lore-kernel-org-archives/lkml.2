Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab2E3Kmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:42:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:43286 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab2E3Kmp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:42:45 -0400
Message-ID: <1338374555.26856.243.camel@twins>
Subject: Re: [PATCH v3 1/6] measure exec_clock for rt sched entities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, devel@openvz.org,
        Paul Turner <pjt@google.com>, Tejun Heo <tj@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, handai.szj@gmail.com,
        Andrew.Phillips@lmax.com, Serge Hallyn <serge.hallyn@canonical.com>
Date: Wed, 30 May 2012 12:42:35 +0200
In-Reply-To: <4FC5F727.2040804@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
	  <1338371317-5980-2-git-send-email-glommer@parallels.com>
	 <1338373759.26856.238.camel@twins> <4FC5F727.2040804@parallels.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 14:32 +0400, Glauber Costa wrote:
> >> +    for_each_sched_rt_entity(rt_se) {
> >> +            rt_rq = rt_rq_of_se(rt_se);
> >> +            schedstat_add(rt_rq, exec_clock, delta_exec);
> >> +    }
> >> +
> >>      if (!rt_bandwidth_enabled())
> >>              return;
> >
> > See, this just makes me sad.. you now have a double
> > for_each_sched_rt_entity() loop.
> 
> The way I read the rt.c code, it it is called from enqueue_task_rt only
> once. 

Ah, what I meant was, right after that !rt_bandwidth_enabled() muck we
do another for_each_sched_rt_entity() walk.
