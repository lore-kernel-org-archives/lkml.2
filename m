Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab1KWPIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:08:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34279 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab1KWPIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:08:17 -0500
Message-ID: <1322060889.14799.73.camel@twins>
Subject: Re: HW perf initialisation as early_initcall
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Wed, 23 Nov 2011 16:08:09 +0100
In-Reply-To: <20111123145658.GM25848@mudshark.cambridge.arm.com>
References: <20111123145658.GM25848@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 14:56 +0000, Will Deacon wrote:
> Hi Peter,
> 
> In commit 004417a6 ("perf, arch: Cleanup perf-pmu init vs lockup-detector"),
> you moved the arch hw perf initialisation into an early initcall to satisfy a
> race with the NMI lock detector (I'm not clear on what the relationship is).

NMI watchdog uses perf, getting the NMI watchdog up early is good,
getting it up before perf is initialized, not so very good :-)

> Anyway, with ARM big/little platforms on the horizon we have the fun of
> heterogeneous PMUs in the sense that:
> 
> 	- They may have different numbers of event counters
> 	- They may support different event types (possibly a distinct set)
> 	- The event encodings for the generalised events may be different
> 
> The latter two points I think can be solved in the back-end by making events
> affine to a particular PMU type (that is, they are only scheduled when the
> profiled task is running on a given PMU type), although I'm not sure how this
> will be exposed to userspace yet. It might be nice to register a separate
> PMU with perf altogether, but I don't think the userspace tools are there
> yet in terms of specifying the destination PMU for an event.

Ow gawd, that's horrid, will you please kick your cpu folks for me.

> The first point is part of a bigger problem, namely that we can only find
> out the PMU topology of the system by probing the device tree. For older
> platforms, we will still probe the PMU of the boot CPU by inspecting the ID
> registers.

And here I throught DT was up _waaay_ early because its used to bring up
the platform itself, do I need to re-educate myself?

> My question is: does the hw perf initialisation really need to be an
> early_initcall and, if so, how much of the perf backend needs to be up and
> running? It may be that the early initcall assumes all PMUs are the same and
> then later on I go and rewrite things like the number of counters.

I think you can get away with doing it later, since you don't use the
NMI watchdog (although if you ever get NMI like functionality you really
should).

> Of course, any ideas regarding the above are more than welcome!

Yeah, I'll try and let it soak in my brain, who knows what it'll come up
with ;-)
