Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab0CROJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:09:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58712 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab0CROJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:09:46 -0400
Date: Thu, 18 Mar 2010 15:09:33 +0100
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
Message-ID: <20100318140933.GE25642@elte.hu>
References: <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318085607.GB2157@elte.hu>
 <4BA1FC80.2000401@redhat.com>
 <20100318105013.GB24464@elte.hu>
 <4BA20EB8.60707@redhat.com>
 <20100318114821.GB13168@elte.hu>
 <4BA21B09.6060706@redhat.com>
 <20100318130047.GA7424@elte.hu>
 <4BA22C72.9030503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA22C72.9030503@redhat.com>
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

> > That is not what i said. I said they are closely related, and where 
> > technologies are closely related, project proximity turns into project 
> > unification at a certain stage.
> 
> I really don't see how.  So what if both qemu and kvm implement an i8254?  
> They can't share any code since the internal APIs are so different. [...]

I wouldnt jump to assumptions there. perf shares some facilities with the 
kernel on the source code level - they can be built both in the kernel and in 
user-space.

But my main thought wasnt even to actually share the implementation - but to 
actually synchronize when a piece of device emulation moves into the kernel. 
It is arguably bad for performance in most cases when Qemu handles a given 
device - so all the common devices should be kernel accelerated.

The version and testing matrix would be simplified significantly as well: as 
kernel and qemu goes hand in hand, they are always on the same version.

> [...] Even worse for the x86 emulator as qemu and kvm are fundamentally 
> different.

So is it your argument that the difference and the duplication in x86 
instruction emulation is a good thing? You said it some time ago that
the kvm x86 emulator was very messy and you wish it was cleaner.

While qemu's is indeed rather different (it's partly a translator/JIT), i'm 
sure the decoder logic could be shared - and qemu has a slow-path 
full-emulation fallback in any case, which is similar to what in-kernel 
emulator does (IIRC ...).

That might have changed meanwhile.

	Ingo
