Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab1AaSMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:12:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693Ab1AaSL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:11:59 -0500
Message-ID: <4D46FB57.2080005@redhat.com>
Date: Mon, 31 Jan 2011 13:11:35 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: [RFC -v7 PATCH 4/7] Add yield_to(task, preempt) functionality.
References: <20110126165657.2ddd2ac9@annuminas.surriel.com>	 <20110126172148.32d07561@annuminas.surriel.com> <1296474542.15234.394.camel@laptop>
In-Reply-To: <1296474542.15234.394.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 06:49 AM, Peter Zijlstra wrote:
> On Wed, 2011-01-26 at 17:21 -0500, Rik van Riel wrote:

>> +       if (yielded)
>> +               yield();
>> +
>> +       return yielded;
>> +}
>> +EXPORT_SYMBOL_GPL(yield_to);
>
> yield() will again acquire rq->lock.. not not simply have
> ->yield_to_task() do everything required and make that an unconditional
> schedule()?

I wanted to reduce code duplication, since this code path
should not be taken all that frequently.  But hey, you're
the maintainer, so I'll implement it your way :)

The patches should be on the way later today :)

-- 
All rights reversed
