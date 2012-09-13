Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab2IMM0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:26:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:44221 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab2IMM03 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:26:29 -0400
Message-ID: <1347539180.7172.0.camel@twins>
Subject: Re: [PATCH v2 2/3] perf: use hrtimer for event multiplexing
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        Robert Richter <robert.richter@amd.com>
Date: Thu, 13 Sep 2012 14:26:20 +0200
In-Reply-To: <CABPqkBQO2fHoidvubDiL9AhCY-FZkk5_WGyPxerT1noH41R53w@mail.gmail.com>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
	 <1347459195-5491-3-git-send-email-eranian@google.com>
	 <1347459764.15764.32.camel@twins>
	 <CABPqkBREFbnJb4C3CqXc0RkKZDXZeCG8S75p3h=fUFNz1TWH-Q@mail.gmail.com>
	 <CABPqkBQw=Y-V9+QsBxG_=sRwt=eO3wZ+p+KvC6PbA+S-AJpG-A@mail.gmail.com>
	 <1347538571.15764.133.camel@twins>
	 <CABPqkBQO2fHoidvubDiL9AhCY-FZkk5_WGyPxerT1noH41R53w@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 14:20 +0200, Stephane Eranian wrote:
> On Thu, Sep 13, 2012 at 2:16 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2012-09-12 at 17:37 +0200, Stephane Eranian wrote:
> >
> >> Note however that the rotation_list is still used in perf_event_task_tick()
> >> to iterate over the ctx which needs unthrottling. We would have to switch
> >> that loop over to a for-each-pmu() which would necessary incur more
> >> iterations as it would include all the SW PMUs.
> >
> > Oh urgh, right. I think that was one of the reasons I bailed on the
> > hrtimer thing, the frequency and throttle stuff.
> >
> > ctx->nr_freq and needs_unthr could help, but yeah.
> 
> I think for now, we could keep rotation list for the unthrottling.
> Multiplexing won't use rotation_list anymore.

wouldn't that still have the problem where we take the sw-pmus off of
the rotation-list?
