Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab2H0UzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:55:11 -0400
Received: from mx2.parallels.com ([64.131.90.16]:39346 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372Ab2H0UzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:55:09 -0400
Message-ID: <503BDDEB.7090901@parallels.com>
Date: Mon, 27 Aug 2012 13:51:55 -0700
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: <mjw@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <peterz@infradead.org>, <mtosatti@redhat.com>, <mingo@redhat.com>,
        <avi@redhat.com>
Subject: Re: [PATCH RFC 0/3] Add guest cpu_entitlement reporting
References: <20120823231346.11681.1502.stgit@lambeau>  <503708C8.2090401@parallels.com> <1345821066.4950.6.camel@lambeau>  <50396173.4020005@parallels.com> <1346082646.8623.8.camel@lambeau>  <503BC16E.2020201@parallels.com> <1346098754.8623.19.camel@lambeau>
In-Reply-To: <1346098754.8623.19.camel@lambeau>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [38.96.16.75]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 01:19 PM, Michael Wolf wrote:
> On Mon, 2012-08-27 at 11:50 -0700, Glauber Costa wrote:
>> On 08/27/2012 08:50 AM, Michael Wolf wrote:
>>> On Sat, 2012-08-25 at 19:36 -0400, Glauber Costa wrote:
>>>> On 08/24/2012 11:11 AM, Michael Wolf wrote:
>>>>> On Fri, 2012-08-24 at 08:53 +0400, Glauber Costa wrote:
>>>>>> On 08/24/2012 03:14 AM, Michael Wolf wrote:
>>>>>>> This is an RFC regarding the reporting of stealtime.  In the case of
>>>>>>> where you have a system that is running with partial processors such as
>>>>>>> KVM the user may see steal time being reported in accounting tools such
>>>>>>> as top or vmstat.  This can cause confusion for the end user.  To
>>>>>>> ease the confusion this patch set adds a sysctl interface to set the
>>>>>>> cpu entitlement.  This is the percentage of cpu that the guest system is
>>>>>>>  expected to receive.  As long as the steal time is within its expected
>>>>>>> range it will show up as 0 in /proc/stat.  The user will then see in the
>>>>>>> accounting tools that they are getting a full utilization of the cpu
>>>>>>> resources assigned to them.
>>>>>>>
>>>>>>
>>>>>> And how is such a knob not confusing?
>>>>>>
>>>>>> Steal time is pretty well defined in meaning and is shown in top for
>>>>>> ages. I really don't see the point for this.
>>>>>
>>>>> Currently you can see the steal time but you have no way of knowing if
>>>>> the cpu utilization you are seeing on the guest is the expected amount.
>>>>> I decided on making it a knob because a guest could be migrated to
>>>>> another system and it's entitlement could change because of hardware or 
>>>>> load differences.  It could simply be a /proc file and report the
>>>>> current entitlement if needed.   As things are currently implemented I 
>>>>> don't see how someone knows if the guest is running as expected or
>>>>> whether there is a problem.
>>>>>
>>>>
>>>> Turning off steal time display won't get even close to displaying the
>>>> information you want. What you probably want is a guest-visible way to
>>>> say how many miliseconds you are expected to run each second. Right?
>>>
>>> It is not clear to me how knowing how many milliseconds you are
>>> expecting to run will help the user.  Currently the users will run top
>>> to see how well the guest is running.  If they see _any_ steal time some
>>> users think they are not getting the full use of their processor
>>> entitlement.
>>>
>>
>> And your plan is just to selectively lie about it, but disabling it with
>> a knob?
> 
> It is about making it very obvious to the end user whether they are
> receiving their cpu entitlement.  If there is more steal time than
> expected that will still show up.  I have experimented, and it seems to
> work, to put the raw stealtime at the end of each cpu line
> in /proc/stat.  That way the raw data is there as well.   
> 
> Do you have another suggestion to communicate to the user whether they
> are receiving their full entitlement?  At the very least shouldn't the
> entitlement reside in a /proc file somewhere so that the user could look
> up the value and "do the math"?
> 

I personally believe Avi is right here. This is something to be done at
the host side. The user can learn this from any tool he is using to
manage his VMs.

Now if you absolutely must inform him from inside the guest, I would go
with the later, informing him in another location. (I am not saying I
agree with this, just that this is less worse)

