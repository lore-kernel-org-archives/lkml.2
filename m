Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab0CQIyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:54:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42269 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab0CQIyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:54:02 -0400
Date: Wed, 17 Mar 2010 09:53:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Anthony Liguori <aliguori@linux.vnet.ibm.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100317085351.GF16374@elte.hu>
References: <20100316130840.GA24808@elte.hu>
 <4B9F84C0.70706@redhat.com>
 <20100316133114.GB575@elte.hu>
 <y0mbpeo1f1y.fsf@fche.csb>
 <20100316155221.GA19699@elte.hu>
 <4B9FC11A.1070507@linux.vnet.ibm.com>
 <20100316175243.GC23859@elte.hu>
 <4B9FC8B2.6070404@linux.vnet.ibm.com>
 <20100316182809.GA26602@elte.hu>
 <4BA00E6A.7080903@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA00E6A.7080903@linux.vnet.ibm.com>
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


* Anthony Liguori <aliguori@linux.vnet.ibm.com> wrote:

> If you want to use a synthetic filesystem as the management interface for 
> qemu, that's one thing.  But you suggested exposing the guest filesystem in 
> its entirely and that's what I disagreed with.

What did you think, that it would be world-readable? Why would we do such a 
stupid thing? Any mounted content should at minimum match whatever policy 
covers the image file. The mounting of contents is not a privilege escallation 
and it is already possible today - just not integrated properly and not 
practical. (and apparently not implemented for all the wrong 'security' 
reasons)

> The guest may encrypt it's disk image.  It still ought to be possible to run 
> perf against that guest, no?

_In_ the guest you can of course run it just fine. (once paravirt bits are in 
place)

That has no connection to 'perf kvm' though, which this patch submission is 
about ...

If you want unified profiling of both host and guest then you need access to 
both the guest and the host. This is what the 'perf kvm' patch is about. 
Please read the patch, i think you might be misunderstanding what it does ...

Regarding encrypted contents - that's really a distraction but the host has 
absolute, 100% control over the guest and there's nothing the guest can do 
about that - unless you are thinking about the sub-sub-case of Orwellian 
DRM-locked-down systems - in which case there's nothing for the host to mount 
and the guest can reject any requests for information on itself and impose 
additional policy that way. So it's a security non-issue.

Note that DRM is pretty much the worst place to look at when it comes to 
usability: DRM lock-down is the anti-thesis of usability. Do you really want 
KVM to match the mind-set of the RIAA and MPAA? Why do you pretend that a 
developer cannot mount his own disk image? Pretty please, help Linux instead, 
where development is driven by usability and accessibility ...

Thanks,

	Ingo
