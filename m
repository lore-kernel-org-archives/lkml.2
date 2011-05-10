Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab1EJUmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 16:42:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41773 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab1EJUmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 16:42:00 -0400
Date: Tue, 10 May 2011 22:41:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/3] perf support for amd guest/host-only bits
Message-ID: <20110510204149.GE21903@elte.hu>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
 <20110510152132.GA25705@elte.hu>
 <20110510155024.GG30996@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510155024.GG30996@amd.com>
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


* Roedel, Joerg <Joerg.Roedel@amd.com> wrote:

> On Tue, May 10, 2011 at 11:21:32AM -0400, Ingo Molnar wrote:
> > 
> > * Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > So any feedback is greatly appreciated :-)
> > 
> > it's nice to see this hw feature utilized :)
> 
> Yeah, I planned to do this for some time now and finally found the time
> to do it :)
> 
> > 
> > > Diffstat:
> > > 
> > >  arch/x86/include/asm/perf_event.h    |    3 +++
> > >  arch/x86/kernel/cpu/perf_event_amd.c |    6 ++++++
> > >  include/linux/perf_event.h           |    5 ++++-
> > >  kernel/perf_event.c                  |    4 ++++
> > >  tools/perf/util/parse-events.c       |   10 +++++++++-
> > >  5 files changed, 26 insertions(+), 2 deletions(-)
> > 
> > I see you have not touched tools/perf/builtin-kvm.c - how does this feature 
> > integrate with the features of 'perf kvm'? (are you using perf kvm by any 
> > chance?)
> 
> builtin-kvm looks like a wrapper for other perf-cmds which just sets up
> some additional state to tell the sub-cmds that guest-symbols need to be
> resolved and so on.
>
> Implementing this into the place where the other exclude-bits get set (which 
> is in generic code) seemed like a good idea to me. Touching builtin-kvm was 
> unnecessary for this.

ok, then let me put it in another way:

'perf kvm' is the tool that is making Linux instrumentation friendlier to KVM 
developers. Can you think of ways to utilize this new feature there?

For example a new 'perf kvm stat' feature could pass the exclusion bits to perf 
stat automatically. 'perf kvm record' could record on the guest only by 
default.

Things like that.

Thanks,

	Ingo
