Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034Ab1KHPnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:43:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46265 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab1KHPnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:43:08 -0500
X-Authority-Analysis: v=2.0 cv=NJxXCjGg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=wom5GMh1gUkA:10 a=CJuhWrxHYpQA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=qU_JxbGTJ8u0H1rP61AA:9 a=jRDU3Q7W_IMD6FwnxrsA:7 a=CjuIK1q_8ugA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Date: Tue, 8 Nov 2011 10:43:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20111108154304.GA4510@home.goodmis.org>
References: <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com>
 <20111106231953.GD4500@thunk.org>
 <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
 <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
 <CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com>
 <20111107203255.GF24234@thunk.org>
 <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com>
 <4EB85969.2010108@codemonkey.ws>
 <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu>
 <20111108093225.GB32533@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108093225.GB32533@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 10:32:25AM +0100, Ingo Molnar wrote:
> 
> None of the perf developers with whom i'm working complained about 
> the shared repo so far - publicly or privately. By all means they are 
> enjoying it and if you look at the stats and results you'll agree 
> that they are highly productive working in that environment.

Just because you brought it up.

I personally find it awkward to work in the linux tools directory. Maybe
this is the reason that I haven't been such a big contributor of perf. I
only pushed ktest into the kernel tools directory because people
convinced me to do so. Having it there didn't seem to bring in many
other developers. Only one other person has contributed to me, and that
was just some minor changes. I still find it awkward to work on ktest
inside the kernel. I have a separate tree just for ktest, and that means
I have all the kernel files sitting there doing nothing just to be able
to work on 2 files.

Then there's the issue of waiting for Linus to pull from me. I posted my
patch set on Oct 28th, and it didn't make it into the merge window. I
don't know if Linus had an issue with it, or it just got lost in the
noise, as Linus has a lot of other things to worry about. This brings up
another question. Does Linus scale? Having more tools in the kernel
repo requires Linus to pull from more sources. Or are we just going to
have to have a "tools" maintainer. This will give a lot of control to
that person who is the gate keeper of the tools directory.

Now I've kept trace-cmd and kernelshark outside the kernel tree. I've
received lots of patches from other developers for it and some nice new
features. It requires me to think hard to keep a nice ABI, and it has
been working nicely. The event parsing is working well and there's even
a library. But I haven't pushed it too hard because I want this to apply
to perf as well. But due to disagreements of where in the kernel tree it
belongs, it has been over a year with no progress. Now we waste 4 bytes
for every event recording a non existent big kernel lock counter. For
recording a million events (which is actually low) that's 4Megs of
wasted kernel memory. New tracepoints are going into the kernel all the
time, and without a library, we are increasing the chance that more
tools will break on changes, and tracepoints will lock down kernel
inovation soon if something is not done.

Anyway, I'm having surgery tomorrow and have other things to work on.

-- Steve


