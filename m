Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab1KIJXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 04:23:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32994 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab1KIJXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 04:23:05 -0500
Date: Wed, 9 Nov 2011 10:21:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Theodore Tso <tytso@MIT.EDU>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git repository,
 tools/perf/ and tools/kvm/
Message-ID: <20111109092109.GF11473@elte.hu>
References: <20111106231953.GD4500@thunk.org>
 <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
 <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
 <CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com>
 <20111107203255.GF24234@thunk.org>
 <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com>
 <4EB85969.2010108@codemonkey.ws>
 <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu>
 <20111108093225.GB32533@elte.hu>
 <20111108154304.GA4510@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108154304.GA4510@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, Nov 08, 2011 at 10:32:25AM +0100, Ingo Molnar wrote:
> > 
> > None of the perf developers with whom i'm working complained 
> > about the shared repo so far - publicly or privately. By all 
> > means they are enjoying it and if you look at the stats and 
> > results you'll agree that they are highly productive working in 
> > that environment.
> 
> Just because you brought it up.
> 
> I personally find it awkward to work in the linux tools directory. 
> Maybe this is the reason that I haven't been such a big contributor 
> of perf. [...]

Well, this is an argument with a long history we've had from the 
moment we started perf - i think the main underlying reason for that 
is that you still see perf as competition to ftrace instead of seeing 
perf the child of ftrace, the next version of ftrace, the next 
iterative step of evolution :-/

Unfortunately there's not much that i can do about that beyond 
telling you that you are IMHO wrong - you as the main ftrace 
developer thinking that it's competition is a self-fulfilling 
expectation.

Eventually someone will do the right thing and implement 'perf trace' 
(there's still the tip:tmp.perf/trace2 prototype branch) and users 
will flock to that workflow because it's so much more intuitive in 
practice. From what i've seen from the short prototype experiments 
i've conducted it's a no-brainer superior workflow and design.

> [...] I only pushed ktest into the kernel tools directory because 
> people convinced me to do so. Having it there didn't seem to bring 
> in many other developers. [...]

It was somewhat similar with perf - contributors only arrived after 
it went upstream, and even then with a delay of a few releases.

Also, and it pains me to have to mention it, but putting a .pl script 
into the kernel repo is not necessarily a reciepe for attracting a 
lot of developers. We went to great lengths to kill the .cc perf 
report file in perf, to keep the programming environment familiar to 
kernel developers and other low level utility folks.

Also, obviously a tool has to be important, interesting and has to 
offer a distinct edge over other tools to attract contributors. Maybe 
tools/testing/ktest/ does not sound that interesting? Naming also 
matters: i sure would have moved it to tools/ktest/, its name already 
suggests that it's about testing, why repeat that twice? Sounds 
weird.

In that sense tools/kvm/ is better than perf: it has already 
attracted a core group of good, productive contributors despite still 
being an out of tree fork.

The point here was that Pekka & co not just clearly enjoys working on 
tools/kvm/ and has no trouble attracting contributors, but also 
*relies* on it being in the kernel tree.

Thanks,

	Ingo
