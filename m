Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab0CVRMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:12:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58934 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab0CVRMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:12:01 -0400
Date: Mon, 22 Mar 2010 18:11:50 +0100
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
Message-ID: <20100322171150.GA15795@elte.hu>
References: <20100321215455.GB13219@elte.hu>
 <4BA7187E.3050405@redhat.com>
 <20100322111411.GC3483@elte.hu>
 <4BA7629B.7020604@redhat.com>
 <20100322124428.GA12475@elte.hu>
 <4BA76810.4040609@redhat.com>
 <20100322143212.GE14201@elte.hu>
 <4BA7821C.7090900@codemonkey.ws>
 <20100322155505.GA18796@elte.hu>
 <4BA7960A.4020504@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7960A.4020504@codemonkey.ws>
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

> >  - Easy default reference to guest instances, and a way for tools to
> >    reference them symbolically as well in the multi-guest case. Preferably
> >    something trustable and kernel-provided - not some indirect information
> >    like a PID file created by libvirt-manager or so.
> 
> A guest is not a KVM concept. [...]

Well, in a sense a guest is a KVM concept too: it's in essence represented via 
the 'vcpu state attached to a struct mm' abstraction that is attached to the 
/dev/kvm file descriptor attached to a Linux process.

Multiple vcpus can be started by the same process to represent SMP, but the 
whole guest notion is present: a Linux MM that carries KVM state.

In that sense when we type 'perf kvm list' we'd like to get a list of all 
currently present guests that the developer has permission to profile: i.e. 
we'd like a list of all [debuggable] Linux tasks that have a KVM instance 
attached to them.

A convenient way to do that would be to use the Qemu process's ->comm[] name, 
and to have a KVM ioctl that gets us a list of all vcpus that the querying 
task has ptrace permission to. [the standard permission check we do for 
instrumentation]

No need for communication with Qemu for that - just an ioctl, and an 
always-guaranteed result that works fine on a whole-system and on a per user 
basis as well.

Thanks,

	Ingo
