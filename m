Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab0CVUrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:47:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48648 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756258Ab0CVUrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:47:07 -0400
Date: Mon, 22 Mar 2010 21:46:50 +0100
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
Message-ID: <20100322204650.GD18126@elte.hu>
References: <20100322143212.GE14201@elte.hu>
 <4BA7821C.7090900@codemonkey.ws>
 <20100322155505.GA18796@elte.hu>
 <4BA796DF.7090005@redhat.com>
 <20100322165107.GD18796@elte.hu>
 <4BA7A406.9050203@redhat.com>
 <20100322173400.GB15795@elte.hu>
 <4BA7B9E0.5080009@codemonkey.ws>
 <20100322192739.GE21919@elte.hu>
 <4BA7C96D.2020702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7C96D.2020702@redhat.com>
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

> On 03/22/2010 09:27 PM, Ingo Molnar wrote:
> >
> >> If your position basically boils down to, we can't trust userspace
> >> and we can always trust the kernel, I want to eliminate any
> >> userspace path, then I can't really help you out.
> >
> > Why would you want to 'help me out'? I can tell a good solution from a bad 
> > one just fine.
> 
> You are basically making a kernel implementation a requirement, instead of 
> something that follows from the requirement.

No, i'm not.

> > You should instead read the long list of disadvantages above, invert them 
> > and list then as advantages for the kernel-based vcpu enumeration 
> > solution, apply common sense and go admit to yourself that indeed in this 
> > situation a kernel provided enumeration of vcpu contexts is the most 
> > robust solution.
> 
> Having qemu enumerate guests one way or another is not a good idea IMO since 
> it is focused on one guest and doesn't have a system-wide entity.  A 
> userspace system-wide entity will work just as well as kernel 
> implementation, without its disadvantages.

A system-wide user-space entity only solves one problem out of the 4 i listed, 
still leaving the other 3:

 - Those special files can get corrupted, mis-setup, get out of sync, or can
   be hard to discover.

 - Apps might start KVM vcpu instances without adhering to the
   system-wide access method.

 - There is no guarantee for the system-wide process to reply to a request -
   while the kernel can always guarantee an enumeration result. I dont want
   'perf kvm' to hang or misbehave just because the system-wide entity has 
   hung.

Really, i think i have to give up and not try to convince you guys about this 
anymore - i dont think you are arguing constructively anymore and i dont want 
yet another pointless flamewar about this.

Please consider 'perf kvm' scrapped indefinitely, due to lack of robust KVM 
instrumentation features: due to lack of robust+universal vcpu/guest 
enumeration and due to lack of robust+universal symbol access on the KVM side. 
It was a really promising feature IMO and i invested two days of arguments 
into it trying to find a workable solution, but it was not to be.

Thanks,

	Ingo
