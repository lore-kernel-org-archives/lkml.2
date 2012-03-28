Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab2C1It5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 04:49:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:35950 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab2C1It4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 04:49:56 -0400
Message-ID: <1332924580.2528.18.camel@twins>
Subject: Re: [RFC PATCH 0/5] perf: Intel uncore pmu counting support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, linux-kernel@vger.kernel.org, ming.m.lin@intel.com,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Wed, 28 Mar 2012 10:49:40 +0200
In-Reply-To: <20120328064928.GA21725@gmail.com>
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>
	 <20120328064928.GA21725@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 08:49 +0200, Ingo Molnar wrote:
> * Yan, Zheng <zheng.z.yan@intel.com> wrote:
> 
> > Hi, all
> > 
> > Here is the RFC patches to add uncore counting support for Nehalem,
> > Sandy Bridge and Sandy Bridge-EP, applied on top of current tip.
> > The code is based on Lin Ming's old patches.
> > 
> > You can use 'perf stat' to access to the uncore pmu. For example:
> > perf stat -a -C 0 -e 'uncore_nhm/config=0xffff/' sleep 1
> 
> My main complaint is that that's not user friendly *AT ALL*.
> 
> You need to make this useful to mere mortals: go through the 
> SDM, categorize interesting looking events, look at how it can 
> be expressed via tooling, add a generic event where appropriate, 
> provide examples, actually *USE* it to improve the kernel or an 
> app and see the workflow as it happens and improve the tooling, 
> etc.

Easiest way out here is add a /sys/bus/event_source/devices/*/events/
directory which contains files who's name we can use as events and who's
contents are of the form we would use given the format/ stuff.

Example, suppose a westmere,

$ cat /sys/bus/event_source/devices/cpu/events/frontend_stalled_cycles
event=0x0e,umask=0x01,inv,cmask=1

I'll review the uncore patches later this week, but I suspect the whole
cpu->node mapping stuff is still not done properly.

Also, quick question, did Intel fix the SNB uncore PMI?
