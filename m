Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab2JLFQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 01:16:48 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:49479 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab2JLFQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 01:16:46 -0400
Message-ID: <5077A7AC.3090905@linux.vnet.ibm.com>
Date: Fri, 12 Oct 2012 10:46:28 +0530
From: preeti <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: peterz@infradead.org, svaidy@linux.vnet.ibm.com, pjt@google.com
Subject: Re: [RFC PATCH 2/2] sched:Pick the apt busy sched group during load
 balancing
References: <20121012044618.18271.88332.stgit@preeti.in.ibm.com> <20121012045047.18271.11550.stgit@preeti.in.ibm.com>
In-Reply-To: <20121012045047.18271.11550.stgit@preeti.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12101205-5564-0000-0000-000004D9539C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

The figures SCHED_GRP1:3200 and SCHED_GRP2:1156 shown below in the
changelog is the probable figure as calculated with the per-entity-
load-tracking metric for the runqueue load.

> If a sched group has passed the test for sufficient load in
> update_sg_lb_stats,to qualify for load balancing,then PJT's
> metrics has to be used to qualify the right sched group as the busiest group.
> 
> The scenario which led to this patch is shown below:
> Consider Task1 and Task2 to be a long running task
> and Tasks 3,4,5,6 to be short running tasks
> 
> 			Task3
> 			Task4
> Task1			Task5
> Task2			Task6
> ------			------
> SCHED_GRP1		SCHED_GRP2
> 
> Normal load calculator would qualify SCHED_GRP2 as
> the candidate for sd->busiest due to the following loads
> that it calculates.
> 
> SCHED_GRP1:2048
> SCHED_GRP2:4096
> 
> Load calculator would probably qualify SCHED_GRP1 as the candidate
> for sd->busiest due to the following loads that it calculates
> 
> SCHED_GRP1:3200
> SCHED_GRP2:1156
> 
Regards
Preeti

