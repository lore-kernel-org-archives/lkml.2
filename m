Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab0CVT1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:27:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40661 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab0CVT1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:27:49 -0400
Date: Mon, 22 Mar 2010 20:27:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
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
Message-ID: <20100322192739.GE21919@elte.hu>
References: <20100322124428.GA12475@elte.hu>
 <4BA76810.4040609@redhat.com>
 <20100322143212.GE14201@elte.hu>
 <4BA7821C.7090900@codemonkey.ws>
 <20100322155505.GA18796@elte.hu>
 <4BA796DF.7090005@redhat.com>
 <20100322165107.GD18796@elte.hu>
 <4BA7A406.9050203@redhat.com>
 <20100322173400.GB15795@elte.hu>
 <4BA7B9E0.5080009@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7B9E0.5080009@codemonkey.ws>
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


* Anthony Liguori <anthony@codemonkey.ws> wrote:

> On 03/22/2010 12:34 PM, Ingo Molnar wrote:
> >This is really just the much-discredited microkernel approach for keeping
> >global enumeration data that should be kept by the kernel ...
> >
> >Lets look at the ${HOME}/.qemu/qmp/ enumeration method suggested by Anthony.
> >There's numerous ways that this can break:
> >
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
> >
> >  - There is no guarantee for the Qemu process to reply to a request - while
> >    the kernel can always guarantee an enumeration result. I dont want 'perf
> >    kvm' to hang or misbehave just because Qemu has hung.
> 
> If your position basically boils down to, we can't trust userspace
> and we can always trust the kernel, I want to eliminate any
> userspace path, then I can't really help you out.

Why would you want to 'help me out'? I can tell a good solution from a bad one 
just fine.

You should instead read the long list of disadvantages above, invert them and 
list then as advantages for the kernel-based vcpu enumeration solution, apply 
common sense and go admit to yourself that indeed in this situation a kernel 
provided enumeration of vcpu contexts is the most robust solution.

It's really as simple as that :-)

Thanks,

	Ingo
