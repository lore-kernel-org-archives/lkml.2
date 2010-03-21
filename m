Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab0CUUhV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:37:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40483 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347Ab0CUUhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:37:19 -0400
Date: Sun, 21 Mar 2010 21:37:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Olivier Galibert <galibert@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
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
Message-ID: <20100321203704.GB30194@elte.hu>
References: <20100318170223.GB9756@elte.hu>
 <4BA25E66.2050800@redhat.com>
 <20100318172805.GB26067@elte.hu>
 <4BA32E1A.2060703@redhat.com>
 <20100319085346.GG12576@elte.hu>
 <4BA3747F.60401@codemonkey.ws>
 <20100321191742.GD25922@elte.hu>
 <4BA67B2F.4030101@redhat.com>
 <20100321200849.GA51323@dspnet.fr.eu.org>
 <4BA67D75.8060809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA67D75.8060809@redhat.com>
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

> On 03/21/2010 10:08 PM, Olivier Galibert wrote:
> >On Sun, Mar 21, 2010 at 10:01:51PM +0200, Avi Kivity wrote:
> >>On 03/21/2010 09:17 PM, Ingo Molnar wrote:
> >>>Adding any new daemon to an existing guest is a deployment and usability
> >>>nightmare.
> >>>
> >>The logical conclusion of that is that everything should be built into
> >>the kernel.  Where a failure brings the system down or worse.  Where you
> >>have to bear the memory footprint whether you ever use the functionality
> >>or not.  Where to update the functionality you need to deploy a new
> >>kernel (possibly introducing unrelated bugs) and reboot.
> >>
> >>If userspace daemons are such a deployment and usability nightmare,
> >>maybe we should fix that instead.
> >Which userspace?  Deploying *anything* in the guest can be a
> >nightmare, including paravirt drivers if you don't have a natively
> >supported in the OS virtual hardware backoff.
> 
> That includes the guest kernel.  If you can deploy a new kernel in the 
> guest, presumably you can deploy a userspace package.

Note that with perf we can instrument the guest with zero guest-kernel 
modifications as well.

We try to reduce the guest impact to a bare minimum, as the difficulties in 
deployment are function of the cross section surface to the guest.

Also, note that the kernel is special with regards to instrumentation: since 
this is the kernel project, we are doing kernel space changes, as we are doing 
them _anyway_. So adding symbol resolution capabilities would be a minimal 
addition to that - while adding a while new guest package for the demon would 
significantly increase the cross section surface.

	Ingo
