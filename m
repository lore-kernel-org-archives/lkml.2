Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab1ECIRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 04:17:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35830 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab1ECIRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 04:17:36 -0400
Date: Tue, 3 May 2011 10:17:14 +0200
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
Subject: Re: [PATCH 4/4] x86, mce: Have MCE persistent event off by default
 for now
Message-ID: <20110503081714.GA6999@elte.hu>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-5-git-send-email-bp@amd64.org>
 <20110503064505.GF7751@elte.hu>
 <20110503072302.GC18979@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503072302.GC18979@aftab>
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

> On Tue, May 03, 2011 at 02:45:05AM -0400, Ingo Molnar wrote:
> > 
> > * Borislav Petkov <bp@amd64.org> wrote:
> > 
> > > From: Borislav Petkov <borislav.petkov@amd.com>
> > > 
> > > This is new functionality and it affects all of x86 so we want to be
> > > very conservative about it and have it off by default for now, in case
> > > something goes awry. You can always enable it by supplying "ras" on the
> > > kernel command line.
> > > 
> > > Also, depending on whether it is enabled or not, we emit the tracepoint
> > > from a different place in the code to pick up additional decoded info.
> > > 
> > > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > > ---
> > >  Documentation/kernel-parameters.txt |    2 ++
> > >  arch/x86/include/asm/mce.h          |    1 +
> > >  arch/x86/kernel/cpu/mcheck/mce.c    |   32 ++++++++++++++++++++++++++++++--
> > >  drivers/edac/mce_amd.c              |    5 +++++
> > >  4 files changed, 38 insertions(+), 2 deletions(-)
> > 
> > the boot flag is fine - but please keep it enabled by default if MCE support is 
> > enabled in the .config, we do not chicken out when it comes to testing new 
> > code! :-)
> 
> Ok, the problem I see with it is that people without a RAS daemon
> running will have the mechanism collecting MCEs in the background, using
> up resources (4 pages per CPU is the buffer) and not doing anything (in
> the best case that is, when we're not broken otherwise).

Well, i'd put it behind a new Kconfig option which is default enabled if MCE 
support is enabled. That way people can still disable it both in the .config 
and on the boot command line as well.

> Do we want to have that on all x86 turned on by default? Or maybe invert the 
> flag semantics so that people can disable it on boot?

Boot flagsshould have feature=on/off kind of obvious semantics.

Thanks,

	Ingo
