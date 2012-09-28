Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab2I1PTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:19:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:34529 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758386Ab2I1PTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:19:32 -0400
Message-ID: <1348845559.3292.84.camel@twins>
Subject: Re: [PATCH 04/31] perf, core: Add generic intx/intx_checkpointed
 counter modifiers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>
Date: Fri, 28 Sep 2012 17:19:19 +0200
In-Reply-To: <20120928145324.GQ16230@one.firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
	 <1348806696-31170-5-git-send-email-andi@firstfloor.org>
	 <1348822920.3292.60.camel@twins>
	 <20120928145324.GQ16230@one.firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 16:53 +0200, Andi Kleen wrote:
> If I moved this into sysfs this would imply that the perf stat -T 
> code would become Haswell specific. As far as I understand normally
> you guys don't want things like that. Would everyone be ok with
> having specific code there? 

Have a look at /sys/bus/event_source/devices/cpu/format/*, that's
already very hardware specific.

What I suggested is something like:

PMU_FORMAT_ATTR(intx, "config:32");
PMU_FORMAT_ATTR(intx_cp "config:33");

For the HSW+ cpus. That should be enough for userspace to create such
events.
