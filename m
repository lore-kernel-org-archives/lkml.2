Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab0FARAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 13:00:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:56332 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756550Ab0FARAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 13:00:04 -0400
Message-ID: <4C053C39.9070405@kernel.org>
Date: Tue, 01 Jun 2010 18:58:33 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       paulus@samba.org, acme@redhat.com, Paul Menage <menage@google.com>
Subject: Re: [PATCH 2/4] sched: adjust when cpu_active and cpuset configurations
 are updated during cpu on/offlining
References: <1275332199-28082-1-git-send-email-tj@kernel.org>	 <1275332199-28082-3-git-send-email-tj@kernel.org> <1275407846.27810.27627.camel@twins>
In-Reply-To: <1275407846.27810.27627.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 01 Jun 2010 16:58:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/01/2010 05:57 PM, Peter Zijlstra wrote:
> I know we all love notifier lists, but doesn't the below code get lots
> more readable if we don't play tricks with notifier priorities and
> simply hardcode the few (perf/sched/cpuset) callbacks into the hotplug
> paths?

Maybe, maybe not.  In this case, I kind of like that sleep failure
case doesn't have to be explicitly rolled back but if you like hard
coding that's fine too.

> Also, I'm afraid you've now inverted the relation between
> cpu_active_mask and parition_sched_domains().
>
> You need to first set/clear the active mask, then rebuild the domain.
> But with your patch parition_sched_domains() gets called in the regular
> DOWN_PREPARE path, while we only clear active at the very end, which
> means we build the wrong domains.

Ah, right forgot about that.  So, the things that need to be ordered
are cpu_active mask update, cpuset configuration and sched domains,
right?

Thanks.

-- 
tejun
