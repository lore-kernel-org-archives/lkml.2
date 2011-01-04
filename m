Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab1ADJJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 04:09:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab1ADJJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 04:09:38 -0500
Message-ID: <4D22E3C0.7010808@redhat.com>
Date: Tue, 04 Jan 2011 11:09:20 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v3 PATCH 0/3] directed yield for Pause Loop Exiting
References: <20110103162637.29f23c40@annuminas.surriel.com> <1294123335.11283.26.camel@marge.simson.net>
In-Reply-To: <1294123335.11283.26.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 08:42 AM, Mike Galbraith wrote:
> A couple questions.
>
> On Mon, 2011-01-03 at 16:26 -0500, Rik van Riel wrote:
> >  When running SMP virtual machines, it is possible for one VCPU to be
> >  spinning on a spinlock, while the VCPU that holds the spinlock is not
> >  currently running, because the host scheduler preempted it to run
> >  something else.
>
> Do you have any numbers?
>
> If I were to, say, run a 256 CPU VM on my quad, would this help me get
> more hackbench or whatever oomph from my (256X80386/20:) box?

First of all, you can't run 256 guests on x86 kvm.  Second, you'll never 
see better performance when you overcommit.  What this patchset does is 
reduce the degradation from utterly ridiculous to something manageable.  
This allows a host to deliver reasonable performance when overcommitted 
vcpus are actually used, but it's not a good idea to run 64 vcpus on a 
32 cpu host.

> >  Both Intel and AMD CPUs have a feature that detects when a virtual
> >  CPU is spinning on a lock and will trap to the host.
>
> Does an Intel Q6600 have this trap gizmo (iow will this do anything at
> all for my little box if I were to try it out).

Likely not.  Run 
http://git.kernel.org/?p=virt/kvm/qemu-kvm.git;a=blob_plain;f=kvm/scripts/vmxcap;hb=HEAD, 
look for 'PAUSE-loop exiting'.  I think the first processors to include 
them were the Nehalem-EXs, and Westmeres have them as well.

-- 
error compiling committee.c: too many arguments to function

