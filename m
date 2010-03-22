Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0CVQvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:51:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49685 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab0CVQvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:51:37 -0400
Date: Mon, 22 Mar 2010 17:51:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100322165107.GD18796@elte.hu>
References: <20100321215455.GB13219@elte.hu>
 <4BA7187E.3050405@redhat.com>
 <20100322111411.GC3483@elte.hu>
 <4BA7629B.7020604@redhat.com>
 <20100322124428.GA12475@elte.hu>
 <4BA76810.4040609@redhat.com>
 <20100322143212.GE14201@elte.hu>
 <4BA7821C.7090900@codemonkey.ws>
 <20100322155505.GA18796@elte.hu>
 <4BA796DF.7090005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA796DF.7090005@redhat.com>
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

> > The crux of the problem is very simple. To quote my earlier mail:
> >
> >  |
> >  | - The inconvenience of having to type:
> >  |      perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms \
> >  |               --guestmodules=/home/ymzhang/guest/modules top
> >  |
> >  |
> >  |   is very obvious even with a single guest. Now multiply that by more guests ...
> >  |
> >
> > For example we want 'perf kvm top' to do something useful by default: it
> > should find the first guest running and it should report its profile.
> >
> > The tool shouldnt have to guess about where the guests are, what their
> > namespaces is and how to talk to them. We also want easy symbolic access to
> > guest, for example:
> >
> >   perf kvm -g OpenSuse-2 record sleep 1

[ Sidenote: i still received no adequate suggestions about how to provide this
  category of technical features. ]

> > I.e.:
> >
> >  - Easy default reference to guest instances, and a way for tools to
> >    reference them symbolically as well in the multi-guest case. Preferably
> >    something trustable and kernel-provided - not some indirect information
> >    like a PID file created by libvirt-manager or so.
> 
> Usually 'layering violation' is trotted out at such suggestions.
> [...]

That's weird, how can a feature request be a 'layering violation'?

If something that users find straightforward and usable is a layering 
violation to you (such as easily being able to access their own files on the 
host as well ...) then i think you need to revisit the definition of that term 
instead of trying to fix the user.

> [...]  I don't like using the term, because sometimes the layers are 
> incorrect and need to be violated.  But it should be done explicitly, not as 
> a shortcut for a minor feature (and profiling is a minor feature, most users 
> will never use it, especially guest-from-host).
> 
> The fact is we have well defined layers today, kvm virtualizes the cpu and 
> memory, qemu emulates devices for a single guest, libvirt manages guests.  
> We break this sometimes but there has to be a good reason.  So perf needs to 
> talk to libvirt if it wants names.  Could be done via linking, or can be 
> done using a pluging libvirt drops into perf.
> 
> >  - Guest-transparent VFS integration into the host, to recover symbols and
> >    debug info in binaries, etc.
> >
> > There were a few responses to that but none really addressed those 
> > problems - they mostly tried to re-define the problem and suggested that i 
> > was wrong to want such capabilities and suggested various inferior 
> > approaches instead. See the thread for the details - i think i covered 
> > every technical suggestion that was made.
> 
> You simply kept ignoring me when I said that if something can be kept out of 
> the kernel without impacting performance, it should be. I don't want 
> emergency patches closing some security hole or oops in a kernel symbol 
> server.

I never suggested an "in kernel space symbol server" which could oops, why 
would i have suggested that? Please point me to an email where i suggested 
that.

> The usability argument is a red herring.  True, it takes time for things to 
> trickle down to distributions and users.  Those who can't wait can download 
> the code and compile, it isn't that difficult.

It's not just "download and compile", it's also "configure correctly for 
several separate major distributions" and "configure to per guest instance 
local rules".

It's far more fragile in practice than you make it appear to be, and since you 
yourself expressed that you are not interested much in the tooling side, how 
can you have adequate experience to judge such matters?

In fact for instrumentation it's beyond a critical threshold of fragility - 
instrumentation above all needs to be accessible, transparent and robust.

If you cannot see the advantages of a properly integrated solution then i 
suspect there's not much i can do to convince you.

And you ignored not just me but you ignored several people in this thread who 
thought the current status quo was inadequate and expressed interest in both 
the VFS integration and in the guest enumeration features.

Thanks,

	Ingo
