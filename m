Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491Ab0FROfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 10:35:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43623 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932434Ab0FROfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 10:35:51 -0400
Date: Fri, 18 Jun 2010 16:35:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
Message-ID: <20100618143532.GA10886@elte.hu>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
 <20100612102558.GA4000@elte.hu>
 <4C15A5D1.1040104@jp.fujitsu.com>
 <20100618094838.GD23977@elte.hu>
 <AANLkTimqRwAjrQ_b8BZ28lEn_Gaz5-SpLULWASHD1fVn@mail.gmail.com>
 <20100618124551.GC7612@elte.hu>
 <AANLkTinaPhAcGra6JdmHCVcj9HrNyG2TP91-A8AnQMZE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinaPhAcGra6JdmHCVcj9HrNyG2TP91-A8AnQMZE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2347]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* huang ying <huang.ying.caritas@gmail.com> wrote:

> On Fri, Jun 18, 2010 at 8:45 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >> >> [...] ??At least APEI will use NMI to report some hardware events (likely
> >> >> error) to kernel. ??So I suppose we will go to have a delayed call as an
> >> >> event handler for APEI.
> >> >
> >> > Yep, that makes sense. I wasnt arguing against the functionality itself, i
> >> > was arguing against the illogical layering that limits its utility. By
> >> > making it part of perf events it becomes a generic part of that framework
> >> > and can be used by anything that deals with events and uses that
> >> > framework.
> >>
> >> I think the the 'layering' in the patchset helps instead of 'limits' its
> >> utility. It is designed to be as general as possible, so that it can be used
> >> by both perf and other NMI users. Do you think so?
> >
> > What other NMI users do you mean? EDAC/MCE is going to go utilize events 
> > as well (away from the horrible /dev/mcelog interface), the NMI watchdog 
> > already did it and the perf tool obviously does as well. There's a few 
> > leftovers like kcrash which isnt really event centric and i dont think it 
> > needs to be converted.
> 
> But why not just make it more general? It does not hurt anyone including 
> perf.

Because it's not actually more generic that way - just look at the code. It's 
x86 specific, plus it ties it to NMI delivery while the concept of delayed 
execution has nothing to do with NMIs.

	Ingo
