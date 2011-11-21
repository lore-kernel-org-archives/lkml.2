Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1KUSCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:02:08 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:53685 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab1KUSCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:02:06 -0500
Message-ID: <4ECA9217.7020205@linux.vnet.ibm.com>
Date: Mon, 21 Nov 2011 23:31:59 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@ucw.cz, lenb@kernel.org,
        ak@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] PM/Memory-hotplug: Avoid task freezing failures
References: <20111117083042.11419.19871.stgit@srivatsabhat.in.ibm.com> <201111192257.19763.rjw@sisk.pl> <4EC8984E.30005@linux.vnet.ibm.com> <201111201124.17528.rjw@sisk.pl> <4EC9D557.9090008@linux.vnet.ibm.com> <20111121164006.GB15314@google.com> <4ECA84A8.5030005@linux.vnet.ibm.com> <20111121175242.GE15314@google.com>
In-Reply-To: <20111121175242.GE15314@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11112118-2674-0000-0000-000001CC7A73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 11:22 PM, Tejun Heo wrote:
> Hello,
> 
> On Mon, Nov 21, 2011 at 10:34:40PM +0530, Srivatsa S. Bhat wrote:
>>>> I haven't tested this solution yet. Let me know if this solution looks
>>>> good and I'll send it out as a patch after testing and analyzing some
>>>> corner cases, if any.
>>
>> I tested this, and it works great! I'll send the patch in some time.
> 
> Awesome.
> 
>>> * I think it would be better to remove direct access to pm_mutex and
>>>   use [un]lock_system_sleep() universally.  I don't think hinging it
>>>   on CONFIG_HIBERNATE_CALLBACKS buys us anything.
>>>
>>
>> Which direct access to pm_mutex are you referring to?
>> Other than suspend/hibernation call paths, I think mem-hotplug is the only
>> subsystem trying to access pm_mutex. I haven't checked thoroughly though. 
>>
>> But yes, using lock_system_sleep() for mutually excluding some code path
>> from suspend/hibernation is good, and that is one reason why I wanted
>> to fix this API ASAP. But as long as memory hotplug is the only direct user
>> of pm_mutex, is it justified to remove the CONFIG_HIBERNATE_CALLBACKS
>> restriction and make it generic? I don't know...
>>
>> Or, are you saying that we should use these APIs even in suspend/hibernate
>> call paths? That's not such a bad idea either...
> 
> Yeap, all.  It's just confusing to have two different types of access
> to a single lock and I don't believe CONFIG_HIBERNATE_CALLBACKS is a
> meaningful optimization in this case.
> 

Ok that sounds good, I'll send a separate patch for that.
Rafael, do you also agree that this would be better?

Thanks,
Srivatsa S. Bhat

