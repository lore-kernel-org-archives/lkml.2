Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab0CVTVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:21:06 -0400
Received: from 8bytes.org ([88.198.83.132]:55064 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702Ab0CVTVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:21:01 -0400
Date: Mon, 22 Mar 2010 20:20:59 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
	project
Message-ID: <20100322192059.GG1940@8bytes.org>
References: <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321203121.GA30194@elte.hu> <20100322111040.GL13108@8bytes.org> <20100322122228.GH3483@elte.hu> <20100322134633.GD1940@8bytes.org> <20100322163215.GC18796@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322163215.GC18796@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 05:32:15PM +0100, Ingo Molnar wrote:
> I dont know how you can find the situation of Alpha comparable, which is a 
> legacy architecture for which no new CPU was manufactored in the past ~10 
> years.
> 
> The negative effects of physical obscolescence cannot be overcome even by the 
> very best of development models ...

The maintainers of that architecture could at least continue to maintain
it. But that is not the case. Most newer syscalls are not available and
overall stability on alpha sucks (kernel crashed when I tried to start
Xorg for example) but nobody cares about it. Hardware is still around
and there are still some users of it.

> > > * Joerg Roedel <joro@8bytes.org> wrote:
> > No, the split-repository situation was the smallest problem after all. Its 
> > was a community thing. If the community doesn't work a single-repo project 
> > will also fail. [...]
> 
> So, what do you think creates code communities and keeps them alive? 
> Developers and code. And the wellbeing of developers are primarily influenced 
> by the repository structure and by the development/maintenance process - i.e. 
> by the 'fun' aspect. (i'm simplifying things there but that's the crux of it.)

Right. A living community needs developers that write new code. And the
repository structure is one important thing. But in my opinion it is not
the most important one. With my 3-4 years experience in the kernel
community I made the experience that the maintainers are the most
important factor. I find a maintainer not commiting or caring about
patches or not releasing new versions much worse than the wrong
repository structure.
oProfile has this problem with its userspace part. I partly made this
bad experience with x86-64 before the architecture merge. KVM does not
have this problem.

> So yes, i do claim that what stiffled and eventually killed off the Oprofile 
> community was the split repository. None of the other Oprofile shortcomings 
> were really unfixable, but this one was. It gave no way for the community to 
> grow in a healthy way, after the initial phase. Features were more difficult 
> and less fun to develop.

The biggest problem oProfile has is that it does not support per-process
measuring. This is indeed not unfixable but it also doesn't fit well in
the overall oProfile concept.

> I simply do not want to see KVM face the same fate, and yes i do see similar 
> warnings signs.

In fact, the development process in KVM has improved over time. In the
early beginnings everything was kept in svn. Avi switched to git some
day but at the time when we had these kvm-XX releases both kernel- and
user-space together were unbisectable. This has improved to a point
where the kernel-part could be bisected. The KVM maintainers and
community have shown in the past that they can address problems with the
development process if they come up.

> Oprofile certainly had good developers and maintainers as well. In the end it 
> wasnt enough ...
> 
> Also, a project can easily still be 'alive' but not reach its full potential. 
> 
> Why do you assume that my argument means that KVM isnt viable today? It can 
> very well still be viable and even healthy - just not _as healthy_ as it could 
> be ...

I am not aware that I made you say anything ;-)

> 
> > > The difference is that we dont have KVM with a decade of history and we 
> > > dont have a 'told you so' KVM reimplementation to show that proves the 
> > > point. I guess it's a matter of time before that happens, because Qemu 
> > > usability is so absymal today - so i guess we should suspend any 
> > > discussions until that happens, no need to waste time on arguing 
> > > hypoteticals.
> > 
> > We actually have lguest which is small. But it lacks functionality and the 
> > developer community KVM has attracted.
> 
> I suggested long ago to merge lguest into KVM to cover non-VMX/non-SVM 
> execution.

That would have been the best. Rusty already started this work and
presented it at the first KVM Forum. But I have never seen patches ...

> > > I think you are rationalizing the status quo.
> > 
> > I see that there are issues with KVM today in some areas. You pointed out 
> > the desktop usability already. I personally have trouble with the 
> > qem-kvm.git because it is unbisectable. But repository unification doesn't 
> > solve the problem here.
> 
> Why doesnt it solve the bisectability problem? The kernel repo is supposed to 
> be bisectable so that problem would be solved.

Because Marcelo and Avi try to keep as close to upstream qemu as
possible. So the qemu repo is regularly merged in qemu-kvm and if you
want to bisect you may end up somewhere in the middle of the qemu
repository which has only very minimal kvm-support.
The problem here is that two qemu repositorys exist. But the current
effort of Anthony is directed to create a single qemu repository. But
thats not done overnight.
Merging qemu into the kernel would make Linus in fact a qemu maintainer.
I am not sure he wants to be that ;-)
 
> In my judgement you'd have to do that more frequently, if KVM was properly 
> weighting its priorities. For example regarding this recent KVM commit of 
> yours:
> 
> | commit ec1ff79084fccdae0dca9b04b89dcdf3235bbfa1
> | Author: Joerg Roedel <joerg.roedel@amd.com>
> | Date:   Fri Oct 9 16:08:31 2009 +0200
> |
> |     KVM: SVM: Add tracepoint for invlpga instruction
> |     
> |     This patch adds a tracepoint for the event that the guest
> |     executed the INVLPGA instruction.
> 
> With integrated KVM tooling i might have insisted for that new tracepoint to 
> be available to users as well via some more meaningful tooling than just a 
> pure tracepoint.
> 
> There's synergies like that all around the place.

True. Tools for better analyzing kvm traces is for sure something that
belongs to tools/kvm. I am not sure if anyone has such tools. If yes,
they should send it upstream.

> > > It's as if you argued in 1990 that the unification of East and West 
> > > Germany wouldnt make much sense because despite clear problems and 
> > > incompatibilites and different styles westerners were still allowed to 
> > > visit eastern relatives and they both spoke the same language after all 
> > > ;-)
> > 
> > Um, hmm. I don't think these situations have enough in common to compare 
> > them ;-)
> 
> Probably, but it's an interesting parallel nevertheless ;-)

That for sure ;-)

	Joerg

