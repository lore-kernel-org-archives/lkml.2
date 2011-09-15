Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab1IOIx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 04:53:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60977 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1IOIx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 04:53:26 -0400
Subject: Re: [PATCH 0/9] Per-cgroup /proc/stat
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, xemul@parallels.com, paul@paulmenage.org,
        lizf@cn.fujitsu.com, daniel.lezcano@free.fr, mingo@elte.hu,
        jbottomley@parallels.com
Date: Thu, 15 Sep 2011 10:53:09 +0200
In-Reply-To: <4E710C93.40609@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	 <1316031196.5040.46.camel@twins> <4E710C93.40609@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316076789.3045.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 17:20 -0300, Glauber Costa wrote:


> Answering just a single point here, if you look closely, it does not 
> duplicate  anything from cpuacct. What it does, is to divide it in more
> fine grained groups than just user/system. But it is not even called 
> more than it already used to be. Also, I change the counters to per-cpu 
> variables instead of percpu counters (so we can access per-cpu data). If 
> there is any perf. change wrt the current code, it comes from that, and 
> since percpu variables are cheaper to update (and summing up is much 
> less frequent), it will end up even cheaper.

I just saw the word statistics and 234 lines added to sched.c and went
mental ;-)

> The steal time feature is really trivial once it is in place.
> 
> About your point of the context switch cost, how would you feel if we 
> optimized it out using static_branch() like it was done for kvm steal time?

Both pjt and me tried, but its hard, part of the problem is also data
structure bloat.
