Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750871Ab1ITNEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:04:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:57384 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1ITNEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:04:47 -0400
Subject: Re: [PATCH 8/9] per-cgroup boot time
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, xemul@parallels.com, paul@paulmenage.org,
        lizf@cn.fujitsu.com, daniel.lezcano@free.fr, mingo@elte.hu,
        jbottomley@parallels.com
Date: Tue, 20 Sep 2011 15:04:20 +0200
In-Reply-To: <4E78890D.1000607@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	  <1316030695-19826-9-git-send-email-glommer@parallels.com>
	 <1316510746.11841.18.camel@twins> <4E78890D.1000607@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316523860.13664.11.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 09:37 -0300, Glauber Costa wrote:

> >> +	getboottime(&boottime);
> >> +	ts = timespec_add(boottime, ca->start_time);
> >> +	jif = ts.tv_sec;
> >>
> >>   	for_each_possible_cpu(i) {
> >>   		cpustat = per_cpu_ptr(ca->cpustat, i);
> >
> >
> > I'm confused, what does it do? You take a boot time timestamp at cgroup
> > creation, add that to all boot-time readings and print the result. How
> > does that make sense? Subtracting the start_time, maybe, that would make
> > the cgroup creation time 0, adding, not so much.
> 
> Boot time represent at which times the machine was booted. In this 
> context, at which time the container/cgroup was created. So it have to 
> be an addition.... don't really understand your question

I think we're all properly confused now :-)

getboottime() gives a time since boot, right? 

You take stamp at cgroup creation: say 50s after boot.

Then on usage you take a new getboottime() reading (which per definition
is > 50s) and add your 50s that you read previous. This results in the
cgroup having 50s of boot-time _MORE_ than the machine. Say you read at
123s, you then add your 50s timestamp, resulting in 173s to report.

If instead you did a subtraction: 123-50=73, you would have reported the
time since cgroup creation.

