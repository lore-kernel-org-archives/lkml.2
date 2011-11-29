Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab1K2GnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 01:43:04 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:50087 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab1K2GnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 01:43:01 -0500
Message-ID: <4ED47EC2.2090802@linux.vnet.ibm.com>
Date: Tue, 29 Nov 2011 12:12:10 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
Newsgroups: gmane.linux.power-management.general,gmane.linux.ports.ppc64.devel,gmane.linux.kernel
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/4] cpuidle: (powerpc) Add cpu_idle_wait() to
 allow switching of idle routines
References: <20111117112815.9191.2322.stgit@localhost6.localdomain6>	<20111117112830.9191.1951.stgit@localhost6.localdomain6>	<1322434096.23348.6.camel@pasglop>	<4ED36A37.3030409@linux.vnet.ibm.com> <1322512522.23348.43.camel@pasglop>
In-Reply-To: <1322512522.23348.43.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11112820-6102-0000-0000-0000004846CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 02:05 AM, Benjamin Herrenschmidt wrote:

> On Mon, 2011-11-28 at 16:32 +0530, Deepthi Dharwar wrote:
> 
>>> Additionally, I'm a bit worried (but maybe we already discussed that a
>>> while back, I don't know) but cpu_idle_wait() has "wait" in the name,
>>> which makes me think it might need to actually -wait- for all cpus to
>>> have come out of the function.
>>
>> cpu_idle_wait is used to ensure that all the CPUs discard old idle
>> handler and update to new one.  Required while changing idle
>> handler on SMP systems.
>>
>>> Now your implementation doesn't provide that guarantee. It might be
>>> fine, I don't know, but if it is, you'd better document it well in the
>>> comments surrounding the code, because as it is, all you do is shoot an
>>> interrupt which will cause the target CPU to eventually come out of idle
>>> some time in the future.
>>
>>
>> I was hoping that sending an explicit reschedule to the cpus would
>> do the trick but sure we can add some documentation around the code.
> 
> Well, the question is what guarantee do you expect. Sending a reschedule
> IPI will take the other CPUs out of the actual sleep mode, but it will
> be some time from there back to getting out of the handler function
> (first back out of hypervisor etc...).
> 
> The code as you implemented it doesn't wait for that to happen. It might
> be fine ... or not. I don't know what semantics you are after precisely.
> 
> Cheers,
> Ben.
> 
> 


Yes, this could be problematic as there is small window for the
race condition to occur . Otherwise we need to manually schedule
it by running a kernel thread but this would definitely have a
overhead and would be an overkill.

Regards,
Deepthi


