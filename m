Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab2E3MMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:12:14 -0400
Received: from mx2.parallels.com ([64.131.90.16]:54812 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab2E3MMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:12:12 -0400
Message-ID: <4FC60E12.4010201@parallels.com>
Date: Wed, 30 May 2012 16:09:54 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
        <handai.szj@gmail.com>, <Andrew.Phillips@lmax.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v3 1/6] measure exec_clock for rt sched entities
References: <1338371317-5980-1-git-send-email-glommer@parallels.com> <1338371317-5980-2-git-send-email-glommer@parallels.com> <1338373759.26856.238.camel@twins> <4FC5F727.2040804@parallels.com> <1338374555.26856.243.camel@twins> <4FC5F99B.2060109@parallels.com> <CAPM31RL-X2GYju-opjUumPq_cfGiRzGowXEOx9Tq4kVEG-z3SA@mail.gmail.com>
In-Reply-To: <CAPM31RL-X2GYju-opjUumPq_cfGiRzGowXEOx9Tq4kVEG-z3SA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 03:00 PM, Paul Turner wrote:
> Does this even need to be hierarchical?  While it's natural for it to
> be in the CFS case, it feels forced here.
>
> You could instead make this rt_rq->local_exec_clock  charging only to
> the parenting rt_rq and post-aggregate when you want to report.  The
> only thing you'd need to be careful of is also accounting children
> somewhere on the parent on destruction (reaped_exec_clock?).
>
> Harking back to symmetry, local_exec_clock is also a potentially
> useful stat on the CFS side of things since it allows you to usefully
> disambiguate versus your children (common case where this is useful is
> calculating usage of threads in the root cgroup); so it wouldn't need
> to be unique to rt_rq.

I can try this approach.
