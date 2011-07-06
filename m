Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab1GFHBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 03:01:09 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:36538 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab1GFHBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 03:01:07 -0400
Date: Wed, 6 Jul 2011 11:01:01 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
        Stephane Eranian <eranian@google.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip, final] perf, x86: Add hw_watchdog_set_attr() in a
 sake of nmi-watchdog on P4
Message-ID: <20110706070101.GG4060@sun>
References: <20110705113620.GS17941@sun>
 <20110705114437.GC15654@elte.hu>
 <20110705114944.GT17941@sun>
 <20110705121421.GU17941@sun>
 <20110705131005.GA5843@elte.hu>
 <1309871841.3282.148.camel@twins>
 <20110705133105.GB5843@elte.hu>
 <1309876851.3282.235.camel@twins>
 <20110705145656.GA18116@elte.hu>
 <20110705152515.GE4060@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705152515.GE4060@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 07:25:15PM +0400, Cyrill Gorcunov wrote:
...
> 
> i don't think it changes much, Ingo, if I change it to bus cycles I still
> will have to setup nmi-watchdog event separately (but simply with bus
> event).
> 
> so an only option is the aliases, i'll try to deal with it but no milestones
> 
> 	Cyrill

Seems I recall one of the problem with aliasing. Look, for example one
cpu-cycles (as native non-halted ticks) is served as nmi-watchdog, then
say perf top is started and it uses non-sleeping ticks (via execution unit
events) for counting cycles. Note the end user doesn't know about it since
this all is transparent. But what if some other user needs execution unit
events via RAW interface and because this event is already borrowed as alias
it never be granted, and what is worse is that a user has no idea why. Is it
acceptable tradeoff?

	Cyrill
