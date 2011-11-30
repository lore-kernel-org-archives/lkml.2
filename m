Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab1K3B0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 20:26:08 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:58039 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab1K3B0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 20:26:05 -0500
Message-ID: <4ED58614.9090204@linux.vnet.ibm.com>
Date: Wed, 30 Nov 2011 06:55:40 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [linux-pm] [RFC PATCH v2 4/4] cpuidle: (POWER) Handle power_save=off
References: <20111117112815.9191.2322.stgit@localhost6.localdomain6> <20111117112906.9191.54050.stgit@localhost6.localdomain6> <1322435233.23348.19.camel@pasglop>	<4ED36A7D.9070308@linux.vnet.ibm.com> <1322512771.23348.45.camel@pasglop> <4ED47F48.2070107@linux.vnet.ibm.com>
In-Reply-To: <4ED47F48.2070107@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11112915-5490-0000-0000-00000039906A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 12:14 PM, Deepthi Dharwar wrote:

> On 11/29/2011 02:09 AM, Benjamin Herrenschmidt wrote:
> 
>> On Mon, 2011-11-28 at 16:33 +0530, Deepthi Dharwar wrote:
>>
>>> On an LPAR if cpuidle is disabled, ppc_md.power_save is still set to
>>> cpuidle_idle_call by default here. This would result in calling of
>>> cpuidle_idle_call repeatedly, only for the call to return -ENODEV. The
>>> default idle is never executed.
>>> This would be a major design flaw. No fallback idle routine.
>>>
>>> We propose to fix this by checking the return value of
>>> ppc_md.power_save() call from void to int.
>>> Right now return value is void, but if we change this to int, this
>>> would solve two problems. One being removing the cast to a function
>>> pointer in the prev patch and this design flaw stated above.
kernel/idle.c:  ppc_md.power_save = NULL;
>>>
>>> So by checking the return value of ppc_md.power_save(), we can invoke
>>> the default idle on failure. But my only concern is about the effects of
>>> changing the ppc_md.power_save() to return int on other powerpc
>>> architectures. Would it be a good idea to change the return type to int
>>> which would help us flag an error and fallback to default idle?
>>
>> I would have preferred an approach where the cpuidle module sets
>> ppc_md.power_save when loaded and restores it when unloaded ... but that
>> would have to go into the cpuidle core as a powerpc specific tweak and
>> might not be generally well received.
>>
>> So go for it, add the return value, but you'll have to update all the
>> idle functions (grep for power_save in arch/powerpc to find them).
>>
> 
> 
> Thanks Ben. Yes, I will update all the idle functions under powerpc.
> I will re-work these patches with the discussed changes.
> 
> Regards,
> Deepthi
> 
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/linux-pm
> 
> 

Hi Ben,

I was trying to add a return value for power_save for all arch/powepc
idle functions but a few of them directly call *.S  routines, as they
are asm.

What would be a good way to change the return value  for asm routines ?
Do we make a change in asm only, put the return value in r3 or write a
wrapper function which would call these asm routines and return an int ?

Regards,
Deepthi

