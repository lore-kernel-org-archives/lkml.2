Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0CVOHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:07:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54819 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab0CVOHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:07:41 -0400
Date: Mon, 22 Mar 2010 15:07:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Avi Kivity <avi@redhat.com>,
       Antoine Martin <antoine@nagafix.co.uk>,
       Olivier Galibert <galibert@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>, libguestfs@redhat.com
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100322140711.GC14201@elte.hu>
References: <4BA68997.60406@redhat.com>
 <20100321212009.GE30194@elte.hu>
 <4BA70F9A.8030304@redhat.com>
 <20100322114824.GF3483@elte.hu>
 <84144f021003220531p391975f2p5a2e0cfd3a2af6d@mail.gmail.com>
 <20100322123726.GH21874@redhat.com>
 <20100322125440.GB12475@elte.hu>
 <20100322130513.GJ21874@redhat.com>
 <20100322135647.GA14201@elte.hu>
 <20100322140106.GN23276@amd.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322140106.GN23276@amd.home.annexia.org>
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


* Richard W.M. Jones <rjones@redhat.com> wrote:

> On Mon, Mar 22, 2010 at 02:56:47PM +0100, Ingo Molnar wrote:
> > Just curious: any plans to extend this to include live read/write access as 
> > well?
> >
> > I.e. to have the 'agent' (guestfsd) running universally, so that
> > tools such as perf and by users could rely on the VFS integration as
> > well, not just disaster recovery tools?
> 
> Totally.  That's not to say there is a definite plan, but we're very open to 
> doing this.  We already wrote the daemon in such a way that it doesn't 
> require the appliance part, but could run inside any existing guest (we've 
> even ported bits of it to Windoze ...).
> 
> The only remaining issue is how access control would be handled.  You 
> obviously wouldn't want anything in the host that can get access to the 
> vmchannel socket to start sending destructive write commands into guests.

By default i'd suggest to put it into a maximally restricted mount point. I.e. 
restrict access to only the security context running libguestfs or so.

( Which in practice will be the user starting the guest, so there will be 
  proper protection from other users while still allowing easy access to the 
  user that has access already. )

	Ingo
