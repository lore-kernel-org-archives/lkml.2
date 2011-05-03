Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab1ECI15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 04:27:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37034 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab1ECI1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 04:27:55 -0400
Date: Tue, 3 May 2011 10:27:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH 3/4] x86, mce: Add persistent MCE event
Message-ID: <20110503082742.GC6999@elte.hu>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-4-git-send-email-bp@amd64.org>
 <20110503064401.GE7751@elte.hu>
 <20110503071833.GB18979@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503071833.GB18979@aftab>
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

> I'm guessing that when we move those to /sysfs, this mechanism will have to 
> change too so it might make sense to move that functionality to persistent.c. 
> Let me see what I can do.

Yes, we really do not want to increase the debugfs mess. This looks like an 
implementational detail but from a tooling POV it's quite essential.

As a starting point check out Peter's patch from November 2010:

  [RFC][PATCH 8/8] perf: Sysfs events

  https://lkml.org/lkml/2010/11/17/489

That patch should still apply cleanly to the latest tree.

In the end we want all events (including regular hw events) to be easily 
available via sysfs enumeration. The goal is that ideally when you type 'perf 
list' it should only access /sys.

Thanks,

	Ingo
