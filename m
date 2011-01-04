Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab1ADQyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:54:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab1ADQyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:54:18 -0500
Message-ID: <4D2350AE.60302@redhat.com>
Date: Tue, 04 Jan 2011 11:54:06 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
References: <20110103162637.29f23c40@annuminas.surriel.com>	<20110103162918.577a9620@annuminas.surriel.com>	<AANLkTim1UFzHjBv52p7tyVyXerCVUVOBSAa3ajwQveuN@mail.gmail.com>	<4D234E60.3010804@redhat.com> <AANLkTim8zmhKjPs-fVdR=65VPd6hybD8HA8pKEyKzm13@mail.gmail.com>
In-Reply-To: <AANLkTim8zmhKjPs-fVdR=65VPd6hybD8HA8pKEyKzm13@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 11:51 AM, Hillf Danton wrote:

>> Wouldn't that break for FIFO and RR tasks?
>>
>> There's a reason all the scheduler folks wanted a
>> per-class yield_to_task function :)
>>
>
> Where is the yield_to callback in the patch for RT schedule class?
> If @p is RT, what could you do?

If the user chooses to overcommit the CPU with realtime
tasks, the user cannot expect realtime response.

For realtime, I have not implemented the yield_to callback
at all because it would probably break realtime semantics
and I assume people will not overcommit the CPU with realtime
tasks anyway.

I could see running a few realtime guests on a system, with
the number of realtime VCPUs not exceeding the number of
physical CPUs.

-- 
All rights reversed
