Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab1ELKyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 06:54:55 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47889 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335Ab1ELKyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 06:54:54 -0400
Date: Thu, 12 May 2011 12:54:21 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] perf: Carve out cgroup-related code
Message-ID: <20110512105421.GC17731@aftab>
References: <20110511121135.GA25865@aftab>
 <1305121600.2914.214.camel@laptop>
 <20110511140208.GD25827@aftab>
 <20110511141342.GA19053@elte.hu>
 <20110511143149.GA26548@aftab>
 <20110511152156.GA21707@elte.hu>
 <20110511170912.GA27362@aftab>
 <20110512103644.GH9937@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512103644.GH9937@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 06:36:44AM -0400, Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@amd64.org> wrote:
> 
> > Done, patch below. I've moved all exports local to kernel/events/* to
> > internal.h. Branch at
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git perf-split
> 
> Beyond the things Peter noticed, there's also this new bit in perf_event.h:
> 
> enum event_type_t {
>         EVENT_FLEXIBLE = 0x1,
>         EVENT_PINNED = 0x2,
>         EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
> };
> 
> this got there from core.c, albeit it's only core.c that uses it.
> 
> If then this should move to internal.h - or stay local to core.c.

event_type_t gets pulled by pushing

ctx_sched_out(..., enum event_type_t event_type)

up into the header since otherwise gcc complains of not seeing the
definition of the third argument.

And yes, it should go to internal.h.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
