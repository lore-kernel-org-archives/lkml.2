Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab1KHJe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 04:34:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48822 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab1KHJeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 04:34:25 -0500
Date: Tue, 8 Nov 2011 10:32:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Pekka Enberg <penberg@kernel.org>,
        Vince Weaver <vince@deater.net>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [F.A.Q.] the advantages of a shared tool/kernel Git repository,
 tools/perf/ and tools/kvm/
Message-ID: <20111108093225.GB32533@elte.hu>
References: <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com>
 <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com>
 <20111106231953.GD4500@thunk.org>
 <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
 <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
 <CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com>
 <20111107203255.GF24234@thunk.org>
 <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com>
 <4EB85969.2010108@codemonkey.ws>
 <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu>
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


* Theodore Tso <tytso@MIT.EDU> wrote:

> On Nov 7, 2011, at 5:19 PM, Anthony Liguori wrote:
> 
> > The kernel ecosystem does not have to be limited to linux.git.  
> > There could be a process to be a "kernel.org project" for 
> > projects that fit a certain set of criteria.  These projects 
> > could all share the Linux kernel release cadence and have a 
> > kernel maintainer as a sponsor or something like that.
> > 
> > That is something that could potentially benefit things like 
> > e2fs-tools and all of the other tools that are tied closely to 
> > the kernel.
> 
> We have that already.  Packages such as e2fsprogs, xfsprogs, 
> xfstests, sparse, git, etc., have git trees under git.kernel.org.  
> And I agree that's the perfect place for kvm-tool and perf.  :-)

I guess this should be a F.A.Q., but it's worth repeating that from 
the perf tooling project perspective, being integrated into the 
kernel tree in the past 2-3 years had *numerous* *massive* advantages 
that improved the project's quality.

The shared repo brought countless advantages that a simple kernel.org 
hosting in a split external tool repo would not have brought.

No ifs and when about it, these are the plain facts:

 - Better features, better ABIs: perf maintainers can enforce clean, 
   functional and usable tooling support *before* committing to an 
   ABI on the kernel side. This is a *huge* deal to improve the 
   quality of the kernel, the ABI and the tooling side and we made 
   use of it a number of times.

   A perf kernel feature has to come with working, high-quality and
   usable tooling support - or it won't go upstream. (I could think
   of numerous other subsystems which would see improvements if they
   enforced this too.)

 - We have a shared Git tree with unified, visible version control. I
   can see kernel feature commits followed by tooling support, in a
   single flow of related commits:

      perf probe: Update perf-probe document
      perf probe: Support --del option
      trace-kprobe: Support delete probe syntax

   With two separate Git repositories this kind of connection between
   the tool and the kernel is inevitably weakened or lost.

 - Easier development, easier testing: if you work on a kernel 
   feature and on matching tooling support then it's *much* easier to
   work in a single tree than working in two or more trees in 
   parallel. I have worked on multi-tree features before, and except
   special exceptions they are generally a big pain to develop.

   It's not just a developer convenience factor: "big pain" 
   inevitably transforms into "lower quality" as well.

 - There's a predictable 3 month release cycle of the perf tool,
   enforced *externally*, by the kernel project. This allowed much
   easier synchronization of kernel and user-space features and
   removes version friction. It also guarantees and simplifies the
   version frequency to packagers and users.

 - We are using and enforcing established quality control and coding
   principles of the kernel project. If we mess up then Linus pushes
   back on us at the last line of defense - and has pushed back on us
   in the past. I think many of the currently external kernel
   utilities could benefit from the resulting rise in quality.
   I've seen separate tool projects degrade into barely usable
   tinkerware - that i think cannot happen to perf, regardless of who
   maintains it in the future.

 - Better debuggability: sometimes a combination of a perf
   change in combination with a kernel change causes a breakage. I
   have bisected the shared tree a couple of times already, instead
   of having to bisect a (100,000 commits x 10,000 commits) combined
   space which much harder to debug ...

 - Code reuse: we can and do share source code between the kernel and
   the tool where it makes sense. Both the tooling and the kernel
   side code improves from this. (Often explicit librarization makes
   little sense due to the additional maintenance overhead of a split
   library project and the impossibly long latency of how the kernel
   can rely on the ready existence of such a newly created library
   project.)

 - [ etc: there's half a dozen of other, smaller positive effects as 
     well. ]

Also, while i'm generally pretty good at being the devil's advocate 
as well, but i've yet to see a *single* serious disadvantage of the 
shared repo:

 - Yes, in principle sharing code could be messy - in practice it is
   not, in fact it cleans things up where we share code and triggers 
   fixes on both sides. Sharing code *works*, as long as there's no 
   artificial project boundary.

 - Yes, in principle we could end up only testing new-kernel+new-tool 
   and regress older ABI or tool versions. In practice it does not 
   happen disproportionately: people (us developers included) do test 
   the other combinations as well and the ABI has been designed in a 
   way to make it backwards and forwards compatible by default. I 
   think we have messed up a surprisingly small number of times so 
   far, considering the complexity and growth rate of the ABI.

 - Yes, in principle we could end up being too kernel centric. In 
   practice people are using perf to measure user-space code far more 
   often - and we ourselves use perf to develop perf tooling, which 
   gives an indirect guarantee as well.

In our experience, the almost 3 years track record of perf gives a 
strong validation to the idea that tools that are closely related to 
the kernel can (and quite likely *should*) prosper in the kernel repo 
itself.

While it was somewhat of an unknowable experiement when we started it 
3 years ago, in hindsight it was a no-brainer decision with *many* 
documented advantages to both to the kernel and to tools/perf/.

So we definitely see correlation between tool quality and the shared 
repo maintenance set-up, and i think the list above gives plenty of 
reason to suspect causation as well ...

Finally, i find it rather weird that the people pushing perf to move 
out of the kernel have not actually *worked* in such a shared repo 
scheme yet...

None of the perf developers with whom i'm working complained about 
the shared repo so far - publicly or privately. By all means they are 
enjoying it and if you look at the stats and results you'll agree 
that they are highly productive working in that environment.

If you look at tools/kvm/ contributors you'll find a very similar 
mind-set and similar experiences - albeit the project is much younger 
and smaller.

*That is what matters*.

So i think you should seriously consider moving your projects *into* 
tools/ instead of trying to get other projects to move out ...

You should at least *try* the unified model before criticising it - 
because currently you guys are preaching about sex while having sworn 
a life long celibacy ;-)

Thanks,

	Ingo

