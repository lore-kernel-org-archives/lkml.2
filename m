Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0CRNBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:01:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55370 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab0CRNBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:01:05 -0400
Date: Thu, 18 Mar 2010 14:00:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100318130047.GA7424@elte.hu>
References: <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318085607.GB2157@elte.hu>
 <4BA1FC80.2000401@redhat.com>
 <20100318105013.GB24464@elte.hu>
 <4BA20EB8.60707@redhat.com>
 <20100318114821.GB13168@elte.hu>
 <4BA21B09.6060706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA21B09.6060706@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 03/18/2010 01:48 PM, Ingo Molnar wrote:
>
> > > It's not inevitable, if the projects are badly run, you'll have high 
> > > latencies, but projects don't have to be badly run.
> >
> > So the 64K dollar question is, why does Qemu still suck?
> 
> Where people sent patches, it doesn't suck (or sucks less). Where they 
> don't, it still sucks. [...]

So is your point that the development process and basic code structure does 
not matter at all, it's just a matter of people sending patches? I beg to 
differ ...

> [...]  And it cost way more than $64K.
> 
> If moving things to tools/ helps, let's move Fedora to tools/.

Those bits of Fedora which deeply relate to the kernel - yes.
Those bits that are arguably separate - nope.

> >> How is a patch for the qemu GUI eject button and the kvm shadow mmu 
> >> related? Should a single maintainer deal with both?
> >
> > We have co-maintainers for perf that have a different focus. It works 
> > pretty well.
> 
> And it works well when I have patches that change x86 core and kvm. But 
> that's no longer a single repository and we have to coordinate.

Actually, it works much better if, contrary to your proposal it ends up in a 
single repo. Last i checked both of us really worked on such a project, run by 
some guy. (Named Linus or so.)

> > Look at git log tools/perf/ and how user-space and kernel-space components 
> > interact in practice. You'll patches that only impact one side, but you'll 
> > see very big overlap both in contributor identity and in patches as well.
> >
> > Also, let me put similar questions in a bit different way:
> >
> >  - ' how is an in-kernel PIT emulation connected to Qemu's PIT emulation? '
> 
> Both implement the same spec.  One is be a code derivative of the other (via 
> Xen).
> 
> >  - ' how is the in-kernel dynticks implementation related to Qemu's
> >      implementation of hardware timers? '
> 
> The quality of host kernel timers directly determines the quality of
> qemu's timer emulation.
> 
> >  - ' how is an in-kernel event for a CD-ROM eject connected to an in-Qemu
> >      eject event? '
> 
> Both implement the same spec.  The kernel of course needs to handle
> all implementation variants, while qemu only needs to implement it
> once.
> 
> >  - ' how is a new hardware virtualization feature related to being able to
> >      configure and use it via Qemu? '
> 
> Most features (example: npt) are transparent to userspace, some are
> not.  When they are not, we introduce an ioctl() to kvm for
> controlling the feature, and a command-line switch to qemu for
> calling it.
> 
> >  - ' how is the in-kernel x86 decoder/emulator related to the Qemu x86
> >      emulator? '
> 
> Both implement the same spec.  Note qemu is not an emulator but a
> binary translator.
> 
> >  - ' how is the performance of the qemu GUI related to the way VGA buffers are
> >      mapped and accelerated by KVM? '
> 
> kvm needs to support direct mapping when possible and efficient data
> transfer when not.  The latter will obviously be much slower.  When
> direct mapping is possible, kvm needs to track pages touched by the
> guest to avoid full screen redraws.  The rest (interfacing to X or
> vnc, implementing emulated hardware acceleration, full-screen mode,
> etc.) are unrelated.
> 
> > They are obviously deeply related.
> 
> Not at all. [...]

You are obviously arguing for something like UML. Fortunately KVM is not that. 
Or i hope it isnt.

> [...]  kvm in fact knows nothing about vga, to take your last
> example. [...]

Look at the VGA dirty bitmap optimization a'ka the KVM_GET_DIRTY_LOG ioctl.

See qemu/kvm-all.c's kvm_physical_sync_dirty_bitmap().

It started out as a VGA optimization (also used by live migration) and even 
today it's mostly used by the VGA drivers - albeit a weak one.

I wish there were stronger VGA optimizations implemented, copying the dirty 
bitmap is not a particularly performant solution. (although it's certainly 
better than full emulation) Graphics performance is one of the more painful 
aspects of KVM usability today.

> [...]  To suggest that qemu needs to be close to the kernel to benefit from 
> the kernel's timer implementation means we don't care about providing 
> quality timing except to ourselves, which luckily isn't the case.

That is not what i said. I said they are closely related, and where 
technologies are closely related, project proximity turns into project 
unification at a certain stage.

> Some time ago the various desktops needed directory change
> notification, and people implemented inotify (or whatever it's
> called today).  No one suggested tools/gnome/ and tools/kde/.

You are misconstruing and misrepresenting my argument - i'd expect better. 
Gnome and KDE runs on other kernels as well and is generally not considered 
close to the kernel.

Do you seriously argue that Qemu has nothing to do with KVM these days?

> > The quality of a development process is not defined by the easy cases 
> > where no project unification is needed. The quality of a development 
> > process is defined by the _difficult_ cases.
> 
> That's true, but we don't have issues at the qemu/kvm boundary. Note we do 
> have issues at the qemu/aio interfaces and qemu/net interfaces (out of which 
> vhost-net was born) but these wouldn't be solved by tools/qemu/.

That was not what i suggested. They would be solved by what i proposed: 
tools/kvm/, right?

Thanks,

	Ingo
