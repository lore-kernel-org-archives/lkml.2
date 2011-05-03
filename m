Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab1ECT5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:57:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37927 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab1ECT5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:57:20 -0400
Date: Tue, 3 May 2011 21:56:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] x86, mce: Have MCE persistent event off by default
 for now
Message-ID: <20110503195658.GA24750@elte.hu>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-5-git-send-email-bp@amd64.org>
 <20110503064505.GF7751@elte.hu>
 <20110503072302.GC18979@aftab>
 <987664A83D2D224EAE907B061CE93D5301C53670E0@orsmsx505.amr.corp.intel.com>
 <20110503195200.GA23243@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503195200.GA23243@aftab>
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

> > Probably make some sense to delay such a message (so that in the boot case 
> > we give the daemon a chance to get started before complaining that it 
> > hasn't shown up for work).
> 
> Yep, that and also I need to address the case for catching earlybird MCEs, 
> when perf hasn't been initialized yet. I'm thinking we could reuse the mcelog 
> buffer and feed those into the RAS daemon after init. Something like that.

I'd suggest that to solve that problem we initialize events earlier and allow 
something like a small static buffer backed event which does not need any 
dynamic memory so it can be enabled early on and can receive events, at the 
same time the MCE hw bits are enabled.

That event can get a larger buffer once the system is more fully up - without 
losing whatever events it is already holding.

Thanks,

	Ingo
