Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab0LENCm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 08:02:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab0LENCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 08:02:41 -0500
Message-ID: <4CFB8D50.6050109@redhat.com>
Date: Sun, 05 Dec 2010 15:02:08 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/3] directed yield for Pause Loop Exiting
References: <20101202144129.4357fe00@annuminas.surriel.com> <20101202224122.GT10050@sequoia.sous-sol.org>
In-Reply-To: <20101202224122.GT10050@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 12:41 AM, Chris Wright wrote:
> * Rik van Riel (riel@redhat.com) wrote:
> >  When running SMP virtual machines, it is possible for one VCPU to be
> >  spinning on a spinlock, while the VCPU that holds the spinlock is not
> >  currently running, because the host scheduler preempted it to run
> >  something else.
> >
> >  Both Intel and AMD CPUs have a feature that detects when a virtual
> >  CPU is spinning on a lock and will trap to the host.
> >
> >  The current KVM code sleeps for a bit whenever that happens, which
> >  results in eg. a 64 VCPU Windows guest taking forever and a bit to
> >  boot up.  This is because the VCPU holding the lock is actually
> >  running and not sleeping, so the pause is counter-productive.
>
> Seems like simply increasing the spin window help in that case?  Or is
> it just too contended a lock (I think they use mcs locks, so I can see a
> single wrong sleep causing real contention problems).

It may, but that just pushes the problem to a more contended lock or to 
a higher vcpu count.  We want something that works after PLE threshold 
tuning has failed.

-- 
error compiling committee.c: too many arguments to function

