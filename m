Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626Ab1KJHtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 02:49:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33950 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757455Ab1KJHt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 02:49:29 -0500
Date: Thu, 10 Nov 2011 08:47:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git repository,
 tools/perf/ and tools/kvm/
Message-ID: <20111110074728.GA12768@elte.hu>
References: <20111106231953.GD4500@thunk.org>
 <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
 <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
 <CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com>
 <20111107203255.GF24234@thunk.org>
 <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com>
 <4EB85969.2010108@codemonkey.ws>
 <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu>
 <20111108093225.GB32533@elte.hu>
 <CAM_iQpU4CsudDYxD=-tayEMmkKGP-hSPEsptC6sir7XDPJvzUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM_iQpU4CsudDYxD=-tayEMmkKGP-hSPEsptC6sir7XDPJvzUA@mail.gmail.com>
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


* Américo Wang <xiyou.wangcong@gmail.com> wrote:

> On Tue, Nov 8, 2011 at 5:32 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > So i think you should seriously consider moving your projects 
> > *into* tools/ instead of trying to get other projects to move out 
> > ...
> >
> > You should at least *try* the unified model before criticising it 
> > - because currently you guys are preaching about sex while having 
> > sworn a life long celibacy ;-)
> 
> Ingo, this is making Linux another BSD... manage everything in a 
> single tree...

It's not an all-or-nothing prospect. Linux user-space consists of 
well in excess of 200 MLOC code. The kernel is 15 MLOC.

I think the system-bound utilities that 'obviously' qualify for 
kernel inclusion are around 1 MLOC in total size, i.e. less than 0.5% 
of all user-space.

> Also, what is your criteria for merging a user-space project into 
> kernel tree?

Well, my criteria go roughly along these lines:

 1) The developers use that model and are productive that way and 
    produce a tool that has a significant upside.

 2) There's significant Linux-specific interactions between the 
    user-space project and the kernel.

 3) The code is clean, well designed and follows the various
    principles laid out in Documentation/CodingStyle and
    Documentation/ManagementStyle so that it can be merged into a
    prominent spot in the kernel tree and the project is ready to
    live with the (non-trivial!) consequences of all that:

        - the project does -stable kernel backports of serious bugs

        - the project follows a strict "no regressions" policy

        - the project follows the kernel release cycle of 'Winter', 
          'Spring', 'Summer' and 'Autumn' releases and follows the 
          merge window requirements and implements the post-rc1
          stabilization cycle.

These are not easy requirements and i can well imagine that many 
projects, even if they qualified on all other counts, would prefer to 
stay out of tree than be subject to such strict release engineering 
constraints.

Also, the requirements can be made stricter with time, based on 
positive and negative experiences. Projects can 'die' and move out of 
the kernel as well if the kernel repo did not work out for them. As 
long as it's all done gradually and on a case by case basis Linux can 
only benefit from this.

Thanks,

	Ingo
