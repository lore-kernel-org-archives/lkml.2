Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab1FQIGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:06:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56740 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab1FQIGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:06:32 -0400
Date: Fri, 17 Jun 2011 10:06:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: Re: [PATCH] oprofile, x86: Fix race in nmi handler while starting
Message-ID: <20110617080618.GA893@elte.hu>
References: <1307465249-20055-1-git-send-email-robert.richter@amd.com>
 <20110609071854.GE20544@elte.hu>
 <20110616152531.GR20052@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616152531.GR20052@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> On 09.06.11 03:18:54, Ingo Molnar wrote:
> > 
> > * Robert Richter <robert.richter@amd.com> wrote:
> > 
> > > In some rare cases, nmis are generated immediately after the 
> > > nmi handler of the cpu was started. This causes the counter not 
> > > to be enabled. Before enabling the nmi handlers we need to set 
> > > variable ctr_running first and make sure its value is written 
> > > to memory.
> > > 
> > > Also, the patch makes all existing barriers a memory barrier 
> > > instead of a compiler barrier only.
> > 
> > Could we *PLEASE* just do the obvious and turn oprofile into a 
> > perf user on x86 too, like ARM already does? Two years down the 
> > line and there's zero progress in that area. We want to obsolete 
> > the Oprofile PMU bits on x86, the infrastructure duplication 
> > causes non-trivial problems like this one.
> 
> Ingo,
> 
> I would rather prefer to spend the effort to add full pmu support 
> to perf. AMD features missing are still IBS and nb performance 
> counters for family 15h. The oprofile kernel driver would become 
> obsolete at all with a new daemon using the perf syscall interface.

Agreed - i just don't see *any* progress on the IBS front: more time 
seems to be spent on fixing and sometimes even extending oprofile 
than on any IBS work.

Thanks,

	Ingo
