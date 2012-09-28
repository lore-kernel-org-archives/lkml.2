Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388Ab2I1P3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:29:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38591 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306Ab2I1P3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:29:12 -0400
Date: Fri, 28 Sep 2012 17:29:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, eranian@google.com, acme@redhat.com,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 04/31] perf, core: Add generic intx/intx_checkpointed counter modifiers
Message-ID: <20120928152911.GU16230@one.firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org> <1348806696-31170-5-git-send-email-andi@firstfloor.org> <1348822920.3292.60.camel@twins> <20120928145324.GQ16230@one.firstfloor.org> <1348845559.3292.84.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348845559.3292.84.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 05:19:19PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-09-28 at 16:53 +0200, Andi Kleen wrote:
> > If I moved this into sysfs this would imply that the perf stat -T 
> > code would become Haswell specific. As far as I understand normally
> > you guys don't want things like that. Would everyone be ok with
> > having specific code there? 
> 
> Have a look at /sys/bus/event_source/devices/cpu/format/*, that's
> already very hardware specific.
> 
> What I suggested is something like:
> 
> PMU_FORMAT_ATTR(intx, "config:32");
> PMU_FORMAT_ATTR(intx_cp "config:33");
> 
> For the HSW+ cpus. That should be enough for userspace to create such
> events.

Still would need new fields, but I presume that could be fit in.

perf stat -T uses these qualifiers and computes some derived
metrics. This would become HSW specific code which has to assume
HSW sysfs events.  Is everyone ok with that?

I also still would like the :t, :c shortcuts, but those could be probably
just hardcoded.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
