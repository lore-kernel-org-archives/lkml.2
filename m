Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab1ELKg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 06:36:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57947 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab1ELKgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 06:36:55 -0400
Date: Thu, 12 May 2011 12:36:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        osrc-patches <osrc-patches@elbe.amd.com>
Subject: Re: [RFC PATCH] perf: Carve out cgroup-related code
Message-ID: <20110512103644.GH9937@elte.hu>
References: <20110511121135.GA25865@aftab>
 <1305121600.2914.214.camel@laptop>
 <20110511140208.GD25827@aftab>
 <20110511141342.GA19053@elte.hu>
 <20110511143149.GA26548@aftab>
 <20110511152156.GA21707@elte.hu>
 <20110511170912.GA27362@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511170912.GA27362@aftab>
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


* Borislav Petkov <bp@amd64.org> wrote:

> Done, patch below. I've moved all exports local to kernel/events/* to
> internal.h. Branch at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git perf-split

Beyond the things Peter noticed, there's also this new bit in perf_event.h:

enum event_type_t {
        EVENT_FLEXIBLE = 0x1,
        EVENT_PINNED = 0x2,
        EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
};

this got there from core.c, albeit it's only core.c that uses it.

If then this should move to internal.h - or stay local to core.c.

Thanks,

	Ingo
