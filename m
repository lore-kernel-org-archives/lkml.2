Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab1KHM46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 07:56:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab1KHM44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 07:56:56 -0500
Date: Tue, 8 Nov 2011 10:56:09 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git
	repository, tools/perf/ and tools/kvm/
Message-ID: <20111108125609.GA14272@ghostprotocols.net>
References: <20111106231953.GD4500@thunk.org> <alpine.LFD.2.02.1111070838520.1823@tux.localdomain> <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy> <CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com> <20111107203255.GF24234@thunk.org> <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com> <4EB85969.2010108@codemonkey.ws> <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu> <20111108093225.GB32533@elte.hu> <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 08, 2011 at 05:21:50AM -0500, Theodore Tso escreveu:
> 
> On Nov 8, 2011, at 4:32 AM, Ingo Molnar wrote:
> > 
> > No ifs and when about it, these are the plain facts:
> > 
> > - Better features, better ABIs: perf maintainers can enforce clean, 
> >   functional and usable tooling support *before* committing to an 
> >   ABI on the kernel side.

> "We don't have to be careful about breaking interface compatibility
> while we are developing new features".

My normal working environment is an MRG PREEMPT_RT kernel (2.6.33.9,
test kernels based on 3.0+) running on enterprise distros while I
develop the userspace part.

So no, at least for me, I don't keep updating the kernel part while
developing userspace.
 
> The flip side of this is that it's not obvious when an interface is
> stable, and when it is still subject to change.  It makes life much
> harder for any userspace code that doesn't live in the kernel.   And I
> think we do agree that moving all of userspace into a single git tree
> makes no sense, right?

Right, but that is the extreme as well, right?
 
> > - We have a shared Git tree with unified, visible version control. I
> >   can see kernel feature commits followed by tooling support, in a
> >   single flow of related commits:
> > 
> >      perf probe: Update perf-probe document
> >      perf probe: Support --del option
> >      trace-kprobe: Support delete probe syntax
> > 
> >   With two separate Git repositories this kind of connection between
> >   the tool and the kernel is inevitably weakened or lost.
 
> "We don't have to clearly document new interfaces between kernel and
> userspace, and instead rely on git commit order for people to figure
> out what's going on with some new interface"

Indeed, documentation is lacking, I think coming from a kernel
standpoint I relied too much in the "documentation is source code"
mantra of old days.

But I realize its a necessity and also that regression testing is as
well another necessity.

I introduced 'perf test' for this later need and rejoice everytime
people submit new test cases, like Jiri and Han did in the past, its
just that we need more of both, documentation and regression testing.

Unfortunately that is not so sexy and I have my hands full not just with
perf :-\
 
> > - Easier development, easier testing: if you work on a kernel 
> >   feature and on matching tooling support then it's *much* easier to
> >   work in a single tree than working in two or more trees in 
> >   parallel. I have worked on multi-tree features before, and except
> >   special exceptions they are generally a big pain to develop.
 
> I've developed in the split tree systems, and it's really not that
> hard.  It does mean you have to be explicit about designing interfaces
> up front, and then you have to have a good, robust way of negotiating
> what features are in the kernel, and what features are supposed by the
> userspace --- but if you don't do that then having good backwards and
> forwards compatibility between different versions of the tool simply
> doesn't exist.
 
> So at the end of the day it question is whether you want to be able to
> (for example) update e2fsck to get better ability to fix more file
> system corruptions, without needing to upgrade the kernel.   If you
> want to be able to use a newer, better e2fsck with an older,
> enterprise kernel, then you have use certain programming disciplines.
> That's where the work is, not in whether you have to maintain two git
> trees or a single git tree.

But it can as well be achieved with a single tree, or do you think
having a single tree makes that impossible to achieve? As I said I do
development basically using the split model at least for testing new
tools on older kernels.

People using the tools while developing mostly the kernel or both
kperf/uperf components do the test on the combined kernel + perf
sources.
 
> > - We are using and enforcing established quality control and coding
> >   principles of the kernel project. If we mess up then Linus pushes
> >   back on us at the last line of defense - and has pushed back on us
> >   in the past. I think many of the currently external kernel
> >   utilities could benefit from the resulting rise in quality.
> >   I've seen separate tool projects degrade into barely usable
> >   tinkerware - that i think cannot happen to perf, regardless of who
> >   maintains it in the future.
 
> That's basically saying that if you don't have someone competent
> managing the git tree and providing quality assurance, life gets hard.
> Sure.   But at the same time, does it scale to move all of userspace
> under one git tree and depending on Linus to push back? 

8 or 80 again :-\
 
> I mean, it would have been nice to move all of GNOME 3 under the Linux
> kernel, so Linus could have pushed back on behalf of all of us power

Sheesh, all of gnome? How closely related and used in kernel development
is gnome? gnome 3?

> users, but as much as many of us would have appreciated someone being
> able to push back against the insanity which is the GNOME design
> process, is that really a good enough excuse to move all of GNOME 3
> into the kernel source tree?   :-)

No, but again, you're taking it to the extreme.

- Arnaldo
