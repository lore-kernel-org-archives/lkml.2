Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab1KIIkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:40:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57836 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab1KIIj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:39:59 -0500
Date: Wed, 9 Nov 2011 09:38:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John Kacur <jkacur@redhat.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20111109083812.GC11473@elte.hu>
References: <CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com>
 <20111107203255.GF24234@thunk.org>
 <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com>
 <4EB85969.2010108@codemonkey.ws>
 <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu>
 <20111108093225.GB32533@elte.hu>
 <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu>
 <20111108125509.GB1022@elte.hu>
 <20111108163331.GJ24234@thunk.org>
 <alpine.LFD.2.00.1111082212560.8887@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1111082212560.8887@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* John Kacur <jkacur@redhat.com> wrote:

> On Tue, 8 Nov 2011, Ted Ts'o wrote:
> 
> > On Tue, Nov 08, 2011 at 01:55:09PM +0100, Ingo Molnar wrote:

> > > I guess you can do well with a split project as well - my main 
> > > claim is that good compatibility comes *naturally* with 
> > > integration.
> > 
> > Here I have to disagree; my main worry is that integration makes 
> > it *naturally* easy for people to skip the hard work needed to 
> > keep a stable kernel/userspace interface.
> > 
> > The other worry which I've mentioned, but which I haven't seen 
> > addressed, is that the even if you can use a perf from a newer 
> > kernel with an older kernel, this causes distributions a huge 
> > amount of pain, since they have to package two different kernel 
> > source packages, and only compile perf from the newer kernel 
> > source package.  This leads to all sorts of confusion from a 
> > distribution packaging point of view.
> > 
> > For example, assume that RHEL 5, which is using 2.6.32 or 
> > something like that, wants to use a newer e2fsck that does a 
> > better job fixing file system corruptions.  If it were bundled 
> > with the kernel, then they would have to package up the v3.1 
> > kernel sources, and have a source RPM that isn't used for 
> > building kernel sources, but just to build a newer version of 
> > e2fsck.  Fortunately, they don't have to do that.  They just pull 
> > down a newer version of e2fsprogs, and package, build, test, and 
> > ship that.
> > 
> > In addition, suppose Red Hat ships a security bug fix which means 
> > a new kernel-image RPM has to be shipped.  Does that mean that 
> > Red Hat has to ship new binary RPM's for any and all tools/* 
> > programs that they have packaged as separate RPM's?  Or should 
> > installing a new kernel RPM also imply dropping new binaries in 
> > /usr/bin/perf, et. al? There are all sorts of packaging questions 
> > that are raised integration, and from where I sit I don't think 
> > they've been adequately solved yet.
> >
>  
> This in practice is not a big deal.
> 
> There are many approaches for how the RPM can be built, but basically
> getting the perf source is just a matter of
> make perf-tar-src-pkg or friends such as
> make perf-tarbz2-src-pkg
> which will create perf-3.2.0-rc1.tar, and perf-3.2.0-rc1.tar.bz2
> respectively which can be used for the src rpms. This tar ball can be used
> as a separate package or subpackage.

Great - the 'perf is impossible for distros' was a common counter 
argument early in the perf project's lifetime - i'm glad it turned 
out to be bogus in practice.

Would it further simplify distro side life if all utilities deeply 
related to the kernel got built together and came in a single well 
working package? kutils-3.2.0-rc1.rpm or such.

They would always upgrade together with the kernel so there would 
never be any forced backporting or separate errata pressure, beyond 
the existing flow of -stable fixes.

We do -stable fixes for tools/perf/ as well, for stability/security 
fixes, naturally - other tools would have to follow the regular 
kernel maintenance process to manage high priority fixes.

Basically distros could rely on the kernel and its utilities being a 
coherent whole, which is expected to work together, which is 
maintained and built together and which, if it regresses, is handled 
by the regular -stable kernel regressions process with high priority.

I expect it would grow one by one - it's not like we can or want to 
force utilities to go into the kernel proper. I'd also expect that 
new tools would be added initially - not existing ones moved. My 
question to you would rather be, would it make the life of distro 
release engineers gradually easier if this space grew gradually over 
the years, adding more and more critical tool functionality?

Thanks,

	Ingo
