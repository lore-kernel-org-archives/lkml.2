Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab0CVTUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:20:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46526 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521Ab0CVTUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:20:47 -0400
Date: Mon, 22 Mar 2010 20:20:33 +0100
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
Message-ID: <20100322192033.GC21919@elte.hu>
References: <20100322124428.GA12475@elte.hu>
 <4BA76810.4040609@redhat.com>
 <20100322143212.GE14201@elte.hu>
 <4BA7821C.7090900@codemonkey.ws>
 <20100322155505.GA18796@elte.hu>
 <4BA796DF.7090005@redhat.com>
 <20100322165107.GD18796@elte.hu>
 <4BA7A406.9050203@redhat.com>
 <20100322173400.GB15795@elte.hu>
 <4BA7AF2D.7060306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7AF2D.7060306@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> > Lets look at the ${HOME}/.qemu/qmp/ enumeration method suggested by 
> > Anthony. There's numerous ways that this can break:
> 
> I don't like it either.  We have libvirt for enumerating guests.

Which has pretty much the same problems to the ${HOME}/.qemu/qmp/ solution, 
obviously.

> >  - Those special files can get corrupted, mis-setup, get out of sync, or can
> >    be hard to discover.
> >
> >  - The ${HOME}/.qemu/qmp/ solution suggested by Anthony has a very obvious
> >    design flaw: it is per user. When i'm root i'd like to query _all_ current
> >    guest images, not just the ones started by root. A system might not even
> >    have a notion of '${HOME}'.
> >
> >  - Apps might start KVM vcpu instances without adhering to the
> >    ${HOME}/.qemu/qmp/ access method.
> 
> - it doesn't work with nfs.

So out of a list of 4 disadvantages your reply is that you agree with 3?

> >  - There is no guarantee for the Qemu process to reply to a request - while
> >    the kernel can always guarantee an enumeration result. I dont want 'perf
> >    kvm' to hang or misbehave just because Qemu has hung.
> 
> If qemu doesn't reply, your guest is dead anyway.

Erm, but i'm talking about a dead tool here. There's a world of a difference 
between 'kvm top' not showing new entries (because the guest is dead), and 
'perf kvm top' hanging due to Qemu hanging.

So it's essentially 4 our of 4. Yet your reply isnt "Ingo you are right" but 
"hey, too bad" ?

> > Really, for such reasons user-space is pretty poor at doing system-wide 
> > enumeration and resource management. Microkernels lost for a reason.
> 
> Take a look at your desktop, userspace is doing all of that everywhere, from 
> enumerating users and groups, to deciding how your disks are named.  The 
> kernel only provides the bare facilities.

We dont do that for robust system instrumentation, for heaven's sake!

By your argument it would be perfectly fine to implement /proc purely via 
user-space, correct?

> > You are committing several grave design mistakes here.
> 
> I am committing on the shoulders of giants.

Really, this is getting outright ridiculous. You agree with me that Anothony 
suggested a technically inferior solution, yet you even seem to be proud of it 
and are joking about it?

And _you_ are complaining about lkml-style hard-talk discussions?

Thanks,

	Ingo
