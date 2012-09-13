Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab2IMMSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:18:01 -0400
Received: from [205.233.59.134] ([205.233.59.134]:53923 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab2IMMR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:17:59 -0400
Message-ID: <1347538571.15764.133.camel@twins>
Subject: Re: [PATCH v2 2/3] perf: use hrtimer for event multiplexing
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        Robert Richter <robert.richter@amd.com>
Date: Thu, 13 Sep 2012 14:16:11 +0200
In-Reply-To: <CABPqkBQw=Y-V9+QsBxG_=sRwt=eO3wZ+p+KvC6PbA+S-AJpG-A@mail.gmail.com>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
	 <1347459195-5491-3-git-send-email-eranian@google.com>
	 <1347459764.15764.32.camel@twins>
	 <CABPqkBREFbnJb4C3CqXc0RkKZDXZeCG8S75p3h=fUFNz1TWH-Q@mail.gmail.com>
	 <CABPqkBQw=Y-V9+QsBxG_=sRwt=eO3wZ+p+KvC6PbA+S-AJpG-A@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 17:37 +0200, Stephane Eranian wrote:

> Note however that the rotation_list is still used in perf_event_task_tick()
> to iterate over the ctx which needs unthrottling. We would have to switch
> that loop over to a for-each-pmu() which would necessary incur more
> iterations as it would include all the SW PMUs.

Oh urgh, right. I think that was one of the reasons I bailed on the
hrtimer thing, the frequency and throttle stuff.

ctx->nr_freq and needs_unthr could help, but yeah.
