Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab2IGTJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:09:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:41301 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2IGTJA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:09:00 -0400
Message-ID: <1347044931.2124.5.camel@twins>
Subject: Re: [PATCH 1/3] perf: use hrtimer for event multiplexing
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com, robert.richter@amd.com
Date: Fri, 07 Sep 2012 21:08:51 +0200
In-Reply-To: <CABPqkBT=2H5WuWZ+uFq39XTTxniVvT6tEuaYDHvaV2VSbjBPDQ@mail.gmail.com>
References: <1347028169-1983-1-git-send-email-eranian@google.com>
	 <1347028169-1983-2-git-send-email-eranian@google.com>
	 <1347032350.18408.88.camel@twins>
	 <CABPqkBT=2H5WuWZ+uFq39XTTxniVvT6tEuaYDHvaV2VSbjBPDQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 19:03 +0200, Stephane Eranian wrote:
> I think having different intervals would be a good thing, especially for uncore.
> But now, I am wondering how this could work without too much overhead.
> Looks like you're suggesting arming multiple hrtimers if multiple PMU are
> overcommitted. Is that right?

Right, we shoulnd't have too many PMUs anyway, let alone over committed
ones, so a timer per cpu per pmu should be fine.

>  As opposed to having a PMU multiplier off of a
> single per-cpu hrtimer.
