Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0LJOzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 09:55:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205Ab0LJOzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 09:55:24 -0500
Message-ID: <4D023F40.3050803@redhat.com>
Date: Fri, 10 Dec 2010 09:54:56 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/3] directed yield for Pause Loop Exiting
References: <20101202144129.4357fe00@annuminas.surriel.com> <20101210050344.GR3158@balbir.in.ibm.com>
In-Reply-To: <20101210050344.GR3158@balbir.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2010 12:03 AM, Balbir Singh wrote:

> This is a good problem statement, there are other things to consider
> as well
>
> 1. If a hard limit feature is enabled underneath, donating the
> timeslice would probably not make too much sense in that case

The idea is to get the VCPU that is holding the lock to run
ASAP, so it can release the lock.

> 2. The implict assumption is that spinning is bad, but for locks
> held for short durations, the assumption is not true. I presume
> by the problem statement above, the h/w does the detection of
> when to pause, but that is not always correct as you suggest above.

The hardware waits a certain number of spins before it traps
to the virt host.  Short-held locks, held by a virtual CPU
that is running, will not trigger the exception.

> 3. With respect to donating timeslices, don't scheduler cgroups
> and job isolation address that problem today?

No.

-- 
All rights reversed
