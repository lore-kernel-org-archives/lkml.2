Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab0CRNb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:31:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55002 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab0CRNbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:31:55 -0400
Date: Thu, 18 Mar 2010 14:31:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Alexander Graf <agraf@suse.de>,
       Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100318133124.GA25642@elte.hu>
References: <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318085607.GB2157@elte.hu>
 <F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de>
 <20100318101025.GA13073@elte.hu>
 <4BA1FEB0.7000400@redhat.com>
 <20100318113527.GA13168@elte.hu>
 <y0m4okdzu4z.fsf@fche.csb>
 <20100318130226.GB7424@elte.hu>
 <4BA22663.7070509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA22663.7070509@redhat.com>
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

> On 03/18/2010 03:02 PM, Ingo Molnar wrote:
> >
> >> [...] What users eagerly replace their kernels?
> >
> > Those 99% who click on the 'install 193 updates' popup.
> >
> 
> Of which 1 is the kernel, and 192 are userspace updates (of which one may be 
> qemu).

I think you didnt understand my (tersely explained) point - which is probably 
my fault. What i said is:

 - distros update the kernel first. Often in stable releases as well if 
   there's a new kernel released. (They must because it provides new hardware
   enablement and other critical changes they generally cannot skip.)

 - Qemu on the other hand is not upgraded with (nearly) that level of urgency.
   Completely new versions will generally have to wait for the next distro
   release.

With in-kernel tools the kernel and the tooling that accompanies the kernel 
are upgraded in the same low-latency pathway. That is a big plus if you are 
offering things like instrumentation (which perf does), which relates closely 
to the kernel.

Furthermore, many distros package up the latest -git kernel as well. They 
almost never do that with user-space packages.

Let me give you a specific example:

I'm running Fedora Rawhide with 2.6.34-rc1 right now on my main desktop, and 
that comes with perf-2.6.34-0.10.rc1.git0.fc14.noarch.

My rawhide box has qemu-kvm-0.12.3-3.fc14.x86_64 installed. That's more than a 
1000 Qemu commits older than the latest Qemu development branch.

So by being part of the kernel repo there's lower latency upgrades and earlier 
and better testing available on most distros.

You made it very clear that you dont want that, but please dont try to claim 
that those advantages do not exist - they are very much real and we are making 
good use of it.

Thanks,

	Ingo
