Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2LQJoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 04:44:12 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39806 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab2LQJoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 04:44:11 -0500
Date: Mon, 17 Dec 2012 10:44:03 +0100
From: Robert Richter <rric@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: suravee.suthikulpanit@amd.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        jacob.shin@amd.com
Subject: Re: [PATCH 1/1] Change IBS PMU to use perf_hw_context
Message-ID: <20121217094403.GF1893@rric.localhost>
References: <1355518662-32071-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20121216090410.GC21690@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121216090410.GC21690@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.12.12 10:04:10, Ingo Molnar wrote:
> 
> * suravee.suthikulpanit@amd.com <suravee.suthikulpanit@amd.com> wrote:
> 
> > From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> > 
> > Currently, the AMD IBS PMU initialize pmu.task_ctx_nr to 
> > perf_invalid_context which only allows IBS to be running only 
> > in system-wide mode (e.g. perf record -a). IBS hardware is 
> > available in each core and should be per-context.  This patch 
> > modifies the task_ctx_nr to use the perf_hw_context (default) 
> > instead.
> 
> I'm wondering how extensively was it tested/verified that it's 
> safe to enable IBS in per context mode as well, and that the 
> profiling results are precise and accurate?

>From the implementation's point of view this is very similar to hw
perf counters. I wouldn't expect any issues here. Since IBS can be
immediatly started/stopped and there is no caching, there won't be any
incomming sample that is not related to that context.

The only potential problem I see could be a security risk in a way
that an IBS sample might expose data related to other contexts such as
cache information. This is similar to uncore/northbridge events so I
don't think this is an issue, but we might want to evaluate this.

> We never used the IBS hardware in this fashion before, so some 
> extra care is prudent - and traces of that extra care should be 
> visible in the changelog as well.

Yeah, a comparison of numbers for IBS and hw counter (-e r076:p,r076
and -e r0C1:p,r0C1) in per-context mode would be useful here.

-Robert
