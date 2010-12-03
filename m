Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab0LCRd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 12:33:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab0LCRd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 12:33:57 -0500
Message-ID: <4CF929E9.6000603@redhat.com>
Date: Fri, 03 Dec 2010 12:33:29 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Mike Galbraith <efault@gmx.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
References: <20101202144129.4357fe00@annuminas.surriel.com> <20101202144423.3ad1908d@annuminas.surriel.com> <1291355656.7633.124.camel@marge.simson.net> <20101203134618.GG27994@linux.vnet.ibm.com> <1291387511.7992.15.camel@marge.simson.net> <4CF90341.4020101@redhat.com> <1291388987.7992.27.camel@marge.simson.net> <4CF90E3D.7090103@redhat.com> <20101203162003.GA13515@linux.vnet.ibm.com> <4CF9242D.4090007@redhat.com> <20101203172954.GC11725@linux.vnet.ibm.com>
In-Reply-To: <20101203172954.GC11725@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 12:29 PM, Srivatsa Vaddagiri wrote:
> On Fri, Dec 03, 2010 at 12:09:01PM -0500, Rik van Riel wrote:
>> I don't see how that is going to help get the lock
>> released, when the VCPU holding the lock is on another
>> CPU.
>
> Even the directed yield() is not guaranteed to get the lock released, given its
> shooting in the dark?

True, that's a fair point.

> Anyway, the intention of yield() proposed was not to get lock released
> immediately (which will happen eventually), but rather to avoid inefficiency
> associated with (long) spinning and at the same time make sure we are not
> leaking our bandwidth to other guests because of a naive yield ..

A KVM guest can run on the host alongside short-lived
processes, though.  How can we ensure that a VCPU that
donates time gets it back again later, when the task
time was donated to may no longer exist?

-- 
All rights reversed
