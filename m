Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab1AFV0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:26:38 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:30542 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab1AFV0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:26:37 -0500
Message-ID: <4D263350.5070008@kernel.org>
Date: Thu, 06 Jan 2011 13:25:36 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, numa: Fix CONFIG_DEBUG_PER_CPU_MAPS without NUMA
 emulation
References: <4D1BC856.4010202@kernel.org> <4D1BC94C.5040100@zytor.com> <AANLkTikknHfA4TQw+SMH-EyJBHoNHXk8Rheq4=K4jNWA@mail.gmail.com> <alpine.DEB.2.00.1012291637270.6040@chino.kir.corp.google.com> <4D1BD928.50701@zytor.com> <alpine.DEB.2.00.1012291702180.7374@chino.kir.corp.google.com> <4D1BE615.4000700@zytor.com> <20101230090648.GB7306@elte.hu> <20101230102815.GA29822@elte.hu> <20101230103002.GA30020@elte.hu> <20101230120153.GA16476@elte.hu> <alpine.DEB.2.00.1012301052050.12995@chino.kir.corp.google.com> <alpine.DEB.2.00.1012301053590.12995@chino.kir.corp.google.com> <alpine.DEB.2.00.1101061238460.30820@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1101061238460.30820@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 12:39 PM, David Rientjes wrote:
> On Thu, 30 Dec 2010, David Rientjes wrote:
> 
>> "x86, numa: Fake node-to-cpumask for NUMA emulation" broke the build when
>> CONFIG_DEBUG_PER_CPU_MAPS is set and CONFIG_NUMA_EMU is not.  This is
>> because it is possible to map a cpu to multiple nodes when NUMA emulation
>> is used; the patch required a physical node address table to find those
>> nodes that was only available when CONFIG_NUMA_EMU was enabled.
>>
>> This extracts the common debug functionality to its own function for
>> CONFIG_DEBUG_PER_CPU_MAPS and uses it regardless of whether
>> CONFIG_NUMA_EMU is set or not.
>>
>> NUMA emulation will now iterate over the set of possible nodes for each
>> cpu and call the new debug function whereas only the cpu's node will be
>> used without NUMA emulation enabled.
>>
>> Reported-by: Ingo Molnar <mingo@elte.hu>
>> Signed-off-by: David Rientjes <rientjes@google.com>
> 
> Ingo, do you know what the status of this fix is?  It's required for 
> x86/numa to build and I'd hate to see all of this fixes miss .38 because 
> of this failure.

If x86/numa would not be pushed to Linus. x86/apic-cleanups should be pushed at first.
or Thomas will take care of it?

Thanks

Yinghai


