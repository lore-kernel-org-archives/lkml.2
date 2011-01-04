Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322Ab1ADKft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 05:35:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab1ADKfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 05:35:48 -0500
Message-ID: <4D22F7E3.7000508@redhat.com>
Date: Tue, 04 Jan 2011 12:35:15 +0200
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
References: <20110103162637.29f23c40@annuminas.surriel.com>	 <1294123335.11283.26.camel@marge.simson.net>  <4D22E3C0.7010808@redhat.com> <1294137134.4379.9.camel@marge.simson.net>
In-Reply-To: <1294137134.4379.9.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 12:32 PM, Mike Galbraith wrote:
> On Tue, 2011-01-04 at 11:09 +0200, Avi Kivity wrote:
> >  On 01/04/2011 08:42 AM, Mike Galbraith wrote:
>
> >  >  If I were to, say, run a 256 CPU VM on my quad, would this help me get
> >  >  more hackbench or whatever oomph from my (256X80386/20:) box?
> >
> >  First of all, you can't run 256 guests on x86 kvm.
>
> I didn't want 256 guests. Just one great big dog slow virtual playpen :)

I meant a 256 vcpu guest.  Certainly you can run 256 guests, you're 
limited only by virtual memory.  Current kvm limit is 64 vcpus.

> >  >  >   Both Intel and AMD CPUs have a feature that detects when a virtual
> >  >  >   CPU is spinning on a lock and will trap to the host.
> >  >
> >  >  Does an Intel Q6600 have this trap gizmo (iow will this do anything at
> >  >  all for my little box if I were to try it out).
> >
> >  Likely not.  Run
> >  http://git.kernel.org/?p=virt/kvm/qemu-kvm.git;a=blob_plain;f=kvm/scripts/vmxcap;hb=HEAD,
> >  look for 'PAUSE-loop exiting'.  I think the first processors to include
> >  them were the Nehalem-EXs, and Westmeres have them as well.
>
> Oh darn, need new box to get all the toys.  Thanks.
>

I have a patchset somewhere that emulates pause-loop exiting by looking 
at rip during timer interrupts.  Unfortunately timer interrupts are very 
rare compared to pause-loop exits, so it's not very helpful.

-- 
error compiling committee.c: too many arguments to function

