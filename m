Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab2IGTK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:10:28 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55224 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab2IGTKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:10:22 -0400
MIME-Version: 1.0
In-Reply-To: <1347044931.2124.5.camel@twins>
References: <1347028169-1983-1-git-send-email-eranian@google.com>
	<1347028169-1983-2-git-send-email-eranian@google.com>
	<1347032350.18408.88.camel@twins>
	<CABPqkBT=2H5WuWZ+uFq39XTTxniVvT6tEuaYDHvaV2VSbjBPDQ@mail.gmail.com>
	<1347044931.2124.5.camel@twins>
Date: Fri, 7 Sep 2012 21:10:20 +0200
Message-ID: <CABPqkBSQwduG2bwz0DYP1HPf+4_SQOMhxTBSnKSX-CmATBa93A@mail.gmail.com>
Subject: Re: [PATCH 1/3] perf: use hrtimer for event multiplexing
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com, robert.richter@amd.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 9:08 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2012-09-07 at 19:03 +0200, Stephane Eranian wrote:
>> I think having different intervals would be a good thing, especially for uncore.
>> But now, I am wondering how this could work without too much overhead.
>> Looks like you're suggesting arming multiple hrtimers if multiple PMU are
>> overcommitted. Is that right?
>
> Right, we shoulnd't have too many PMUs anyway, let alone over committed
> ones, so a timer per cpu per pmu should be fine.
>
>>  As opposed to having a PMU multiplier off of a
>> single per-cpu hrtimer.

That's true. I started modifying my code to implement your suggestion.
We'll see how it goes. Then we would have to export that mux interval
via sysfs for each PMU.
