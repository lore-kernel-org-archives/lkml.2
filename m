Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2K1SpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:45:10 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:37677 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab2K1SpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:45:07 -0500
Message-ID: <50B65BA9.4060705@linux.vnet.ibm.com>
Date: Wed, 28 Nov 2012 12:44:57 -0600
From: Michael Wolf <mjw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, riel@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, mtosatti@redhat.com, mingo@redhat.com,
        anthony@codemonkey.ws,
        "gleb@redhat.com >> Gleb Natapov" <gleb@redhat.com>
Subject: Re: [PATCH 0/5] Alter steal time reporting in KVM
References: <20121126203603.28840.38736.stgit@lambeau> <50B47E40.5030805@parallels.com> <50B4D7E8.9020306@linux.vnet.ibm.com> <50B5CF32.9030603@parallels.com>
In-Reply-To: <50B5CF32.9030603@parallels.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12112818-3864-0000-0000-000005C31495
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 02:45 AM, Glauber Costa wrote:
> On 11/27/2012 07:10 PM, Michael Wolf wrote:
>> On 11/27/2012 02:48 AM, Glauber Costa wrote:
>>> Hi,
>>>
>>> On 11/27/2012 12:36 AM, Michael Wolf wrote:
>>>> In the case of where you have a system that is running in a
>>>> capped or overcommitted environment the user may see steal time
>>>> being reported in accounting tools such as top or vmstat.  This can
>>>> cause confusion for the end user.  To ease the confusion this patch set
>>>> adds the idea of consigned (expected steal) time.  The host will
>>>> separate
>>>> the consigned time from the steal time.  The consignment limit passed
>>>> to the
>>>> host will be the amount of steal time expected within a fixed period of
>>>> time.  Any other steal time accruing during that period will show as the
>>>> traditional steal time.
>>> If you submit this again, please include a version number in your series.
>> Will do.  The patchset was sent twice yesterday by mistake.  Got an
>> error the first time and didn't
>> think the patches went out.  This has been corrected.
>>> It would also be helpful to include a small changelog about what changed
>>> between last version and this version, so we could focus on that.
>> yes, will do that.  When I took the RFC off the patches I was looking at
>> it as a new patchset which was
>> a mistake.  I will make sure to add a changelog when I submit again.
>>> As for the rest, I answered your previous two submissions saying I don't
>>> agree with the concept. If you hadn't changed anything, resending it
>>> won't change my mind.
>>>
>>> I could of course, be mistaken or misguided. But I had also not seen any
>>> wave of support in favor of this previously, so basically I have no new
>>> data to make me believe I should see it any differently.
>>>
>>> Let's try this again:
>>>
>>> * Rik asked you in your last submission how does ppc handle this. You
>>> said, and I quote: "In the case of lpar on POWER systems they simply
>>> report steal time and do not alter it in any way.
>>> They do however report how much processor is assigned to the partition
>>> and that information is in /proc/ppc64/lparcfg."
>> Yes, but we still get questions from users asking what is steal time?
>> why am I seeing this?
>>> Now, that is a *way* more sensible thing to do. Much more. "Confusing
>>> users" is something extremely subjective. This is specially true about
>>> concepts that are know for quite some time, like steal time. If you out
>>> of a sudden change the meaning of this, it is sure to confuse a lot more
>>> users than it would clarify.
>> Something like this could certainly be done.  But when I was submitting
>> the patch set as
>> an RFC then qemu was passing a cpu percentage that would be used by the
>> guest kernel
>> to adjust the steal time. This percentage was being stored on the guest
>> as a sysctl value.
>> Avi stated he didn't like that kind of coupling, and that the value
>> could get out of sync.  Anthony stated "The guest shouldn't need to know
>> it's entitlement. Or at least, it's up to a management tool to report
>> that in a way that's meaningful for the guest."
>>
>> So perhaps I misunderstood what they were suggesting, but I took it to
>> mean that they did not
>> want the guest to know what the entitlement was.  That the host should
>> take care of it and just
>> report the already adjusted data to the guest.  So in this version of
>> the code the host would use a set
>> period for a timer and be passed essentially a number of ticks of
>> expected steal time.  The host
>> would then use the timer to break out the steal time into consigned and
>> steal buckets which would be
>> reported to the guest.
>>
>> Both the consigned and the steal would be reported via /proc/stat. So
>> anyone needing to see total
>> time away could add the two fields together.  The user, however, when
>> using tools like top or vmstat
>> would see the usage based on what the guest is entitled to.
>>
>> Do you have suggestions for how I can build consensus around one of the
>> two approaches?
>>
> Before I answer this, can you please detail which mechanism are you
> using to enforce the entitlement? Is it the cgroup cpu controller, or
> something else?
It is setup using cpu overcommit.  But the request was for something 
that would work in both
the overcommit environment as well as when hard capping is being used.

>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

