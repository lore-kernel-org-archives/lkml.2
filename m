Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab2FULlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 07:41:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37393 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab2FULlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 07:41:08 -0400
Message-ID: <1340278853.21745.178.camel@twins>
Subject: Re: [PATCH V6 0/13] perf: Intel uncore pmu counting support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Thu, 21 Jun 2012 13:40:53 +0200
In-Reply-To: <CABPqkBTESKqVG6shXsLi85w=ZJ=1hXxu8+_7tNp23euds8JPbg@mail.gmail.com>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
	 <1340208092.21745.114.camel@twins> <4FE28823.80704@intel.com>
	 <CABPqkBTi8-yKg_kzFTwLe1_m2Zprt5vGk9WPQW14yHQpy=PiWw@mail.gmail.com>
	 <4FE2DE9A.70202@intel.com>
	 <CABPqkBTESKqVG6shXsLi85w=ZJ=1hXxu8+_7tNp23euds8JPbg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 11:13 +0200, Stephane Eranian wrote:

> >>> How about treat the 'cpu' parameter for uncore event as socket id instead
> >>> of cpu id?
> >>>
> >> But that does not address the use case of Peter, i.e., no cpu parameter passed.
> >> Looks like sysfs might be the only way to do this in a portable manner.
> >>
> > It does. For example, on a dual socket system, perf can only register uncore
> > counter with 'cpu' parameter is equal to 0 or 1. This method is hacky, but it
> > requires minimal change for the kernel and perf tool.
> >
> I was saying, I don't want to have to pass -C x with -a and yet have perf stat
> only instantiate the event once per socket. I think that's what PeterZ was
> asking about.

What Zheng is saying is that -a will iterate [0..nr_cpus), but since
we're interpreting the sys_perf_event_open(.cpu) argument as node, we'll
fail the syscall with -EINVAL or so for .cpu >= nr_node_ids.

This way, we'll only create one counter per node.

I would work, but its not pretty since we still don't know what we're
iterating.
