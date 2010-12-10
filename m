Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab0LJLI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 06:08:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:49257 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab0LJLI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 06:08:58 -0500
Message-ID: <4D020A53.8020500@kernel.org>
Date: Fri, 10 Dec 2010 12:09:07 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, eric.dumazet@gmail.com, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, penberg@kernel.org
Subject: Re: [PATCH UPDATED#3 04/16] x86: setup_local_APIC() must always be
 called with preemption disabled
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-5-git-send-email-tj@kernel.org> <4D00B3B9.7060702@kernel.org> <alpine.LFD.2.00.1012092253530.2653@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012092253530.2653@localhost6.localdomain6>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Dec 2010 11:08:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 10:56 PM, Thomas Gleixner wrote:
> On Thu, 9 Dec 2010, Tejun Heo wrote:
> 
>> setup_local_APIC() is used to setup local APIC early during CPU
>> initialization and already assumes that preemption is disabled on
>> entry.  However, The function unnecessarily disables and enables
>> preemption and uses smp_processor_id() multiple times in and out of
>> the nested preemption disabled section.  This gives the wrong
>> impression that the function might be able to handle being called with
>> preemption enabled and/or migrated to another processor in the middle.
>>
>> Make it clear that the function is always called with preemption
>> disabled, drop the confusing preemption disable block and call
>> smp_processor_id() once at the beginning of the function.
> 
> AFAICT, this one is completely unrelated to that NUMA cleanup, right ?
> 
> So this can be applied independent and should never have been part of
> that NUMA series in the first place.

Originally, it was a trivial prep patch.  Anyways, I'll push it
to the top of the series so that it can be taken separately.

Thanks.

-- 
tejun
