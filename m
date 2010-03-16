Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966517Ab0CPPHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:07:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966479Ab0CPPH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:07:28 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from host side
References: <20100316102052.GC10069@elte.hu> <4B9F603B.4080004@redhat.com>
	<20100316105021.GA14344@elte.hu> <4B9F671D.5060001@redhat.com>
	<20100316112500.GA5337@elte.hu> <4B9F77E7.2060101@redhat.com>
	<20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com>
	<20100316130840.GA24808@elte.hu> <4B9F84C0.70706@redhat.com>
	<20100316133114.GB575@elte.hu>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 16 Mar 2010 11:06:49 -0400
In-Reply-To: <20100316133114.GB575@elte.hu> (Ingo Molnar's message of "Tue, 16 Mar 2010 14:31:14 +0100")
Message-ID: <y0mbpeo1f1y.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo Molnar <mingo@elte.hu> writes:

> [...]
>> >I.e. we really want to be able users to:
>> >
>> >  1) have it all working with a single guest, without having to specify 'which'
>> >     guest (qemu PID) to work with. That is the dominant usecase both for
>> >     developers and for a fair portion of testers.
>> 
>> That's reasonable if we can get it working simply.
>
> IMO such ease of use is reasonable and required, full stop.
> If it cannot be gotten simply then that's a bug: either in the code, or in the 
> design, or in the development process that led to the design. Bugs need 
> fixing. [...]

Perhaps the fact that kvm happens to deal with an interesting
application area (virtualization) is misleading here.  As far as the
host kernel or other host userspace is concerned, qemu is just some
random unprivileged userspace program (with some *optional* /dev/kvm
services that might happen to require temporary root).

As such, perf trying to instrument qemu is no different than perf
trying to instrument any other userspace widget.  Therefore, expecting
'trusted enumeration' of instances is just as sensible as using
'trusted ps' and 'trusted /var/run/FOO.pid files'.


- FChE
