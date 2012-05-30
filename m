Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab2E3Kn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:43:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:43317 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab2E3Knz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:43:55 -0400
Message-ID: <1338374628.26856.244.camel@twins>
Subject: Re: [PATCH v3 3/6] expose fine-grained per-cpu data for cpuacct
 stats
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, devel@openvz.org,
        Paul Turner <pjt@google.com>, Tejun Heo <tj@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, handai.szj@gmail.com,
        Andrew.Phillips@lmax.com, Serge Hallyn <serge.hallyn@canonical.com>
Date: Wed, 30 May 2012 12:43:48 +0200
In-Reply-To: <4FC5F7A0.2000201@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
	  <1338371317-5980-4-git-send-email-glommer@parallels.com>
	 <1338374041.26856.241.camel@twins> <4FC5F7A0.2000201@parallels.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 14:34 +0400, Glauber Costa wrote:
> On 05/30/2012 02:34 PM, Peter Zijlstra wrote:
> > On Wed, 2012-05-30 at 13:48 +0400, Glauber Costa wrote:
> >
> >> +static int cpuacct_stats_percpu_show(struct cgroup *cgrp, struct cftype *cft,
> >> +				     struct cgroup_map_cb *cb)
> >> +{
> >> +	struct cpuacct *ca = cgroup_ca(cgrp);
> >> +	int cpu;
> >> +
> >> +	for_each_online_cpu(cpu) {
> >> +		do_fill_cb(cb, ca, "user", cpu, CPUTIME_USER);
> >> +		do_fill_cb(cb, ca, "nice", cpu, CPUTIME_NICE);
> >> +		do_fill_cb(cb, ca, "system", cpu, CPUTIME_SYSTEM);
> >> +		do_fill_cb(cb, ca, "irq", cpu, CPUTIME_IRQ);
> >> +		do_fill_cb(cb, ca, "softirq", cpu, CPUTIME_SOFTIRQ);
> >> +		do_fill_cb(cb, ca, "guest", cpu, CPUTIME_GUEST);
> >> +		do_fill_cb(cb, ca, "guest_nice", cpu, CPUTIME_GUEST_NICE);
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >
> > Uhm, hotplug anyone?
> What's with hotplug ?


Who's to say all cpus are online at this point? If you don't want to
make the files come and go with hotplug, one should use
for_each_possible_cpu().


