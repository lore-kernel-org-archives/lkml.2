Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab1ADRxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:53:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab1ADRxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:53:48 -0500
Message-ID: <4D235E9D.1040603@redhat.com>
Date: Tue, 04 Jan 2011 12:53:33 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Hillf Danton <dhillf@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
References: <20110103162637.29f23c40@annuminas.surriel.com>	 <20110103162918.577a9620@annuminas.surriel.com>	 <AANLkTim1UFzHjBv52p7tyVyXerCVUVOBSAa3ajwQveuN@mail.gmail.com>	 <4D234E60.3010804@redhat.com>	 <AANLkTim8zmhKjPs-fVdR=65VPd6hybD8HA8pKEyKzm13@mail.gmail.com> <1294160890.2016.171.camel@laptop>
In-Reply-To: <1294160890.2016.171.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 12:08 PM, Peter Zijlstra wrote:
> On Wed, 2011-01-05 at 00:51 +0800, Hillf Danton wrote:
>> Where is the yield_to callback in the patch for RT schedule class?
>> If @p is RT, what could you do?
>
> RT guests are a pipe dream, you first need to get the hypervisor (kvm in
> this case) to be RT, which it isn't. Then you either need to very
> statically set-up the host and the guest scheduling constraints (not
> possible with RR/FIFO) or have a complete paravirt RT scheduler which
> communicates its requirements to the host.

There's a limited use case.

One host can have a few RT guests, say a host with 8 CPUs
can have up to 6 or 7 RT VCPUs.  Those guests get top
priority.

The host can then have some other, low priority, guests
that scavenge remaining CPU time.

In this case, no yield_to is required for RT guests,
because they do not do overcommit.

-- 
All rights reversed
