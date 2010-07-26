Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab0GZKHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 06:07:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab0GZKHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 06:07:53 -0400
Message-ID: <4C4D5F4F.8080002@redhat.com>
Date: Mon, 26 Jul 2010 18:11:27 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: huang ying <huang.ying.caritas@gmail.com>, linux-kernel@vger.kernel.org,
        nhorman@redhat.com, akpm@linux-foundation.org
Subject: Re: [Patch] kexec: increase max of kexec segments and use dynamic
  allocation
References: <20100722061810.5659.87609.sendpatchset@localhost.localdomain>	<m1wrso2foi.fsf@fess.ebiederm.org> <4C47E7C9.60608@redhat.com>	<m1iq482duy.fsf@fess.ebiederm.org>	<AANLkTikZTGYl2NIFzcTCG2DAaMefhnJAkSHIoJN22QoI@mail.gmail.com> <m1lj90p8yp.fsf@fess.ebiederm.org>
In-Reply-To: <m1lj90p8yp.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/10 10:54, Eric W. Biederman wrote:
> huang ying<huang.ying.caritas@gmail.com>  writes:
>
>> On Thu, Jul 22, 2010 at 3:08 PM, Eric W. Biederman
>> <ebiederm@xmission.com>  wrote:
>>> Cong Wang<amwang@redhat.com>  writes:
>>>
>>>> On 07/22/10 14:28, Eric W. Biederman wrote:
>>>>> Amerigo Wang<amwang@redhat.com>    writes:
>>>>>
>>>>>> Currently KEXEC_SEGMENT_MAX is only 16 which is too small for machine with
>>>>>> many memory ranges. Increase this hard limit to 1024 which is reasonably large,
>>>>>> and change ->segment from a static array to a dynamically allocated memory.
>>>>>
>>>>> ???
>>>>>
>>>>> This should be about segments in the executable being loaded.  What
>>>>> executable has one segment for each range of physical memory?
>>>>>
>>>>> Not that generalizing this is a bad idea but with a comment that
>>>>> seems entirely wrong I am wondering what the problem really is.
>>>>>
>>>>
>>>> Ah, I think Neil should explain this.
>>>>
>>>> He made a patch which includes many memory ranges, caused kexec
>>>> fails to load the kernel. Increasing this limit and the corresponding
>>>> one in kexec-tools fixes the problem. His patch is not in upstream
>>>> kexec-tools, AFAIK.
>>>>
>>>> However, even if we don't consider that patch, isn't 16 too small too?
>>>
>>> Generally you just need one physical hunk for the code, maybe a second
>>> for the initrd.
>>>
>>> It is perfectly fine to raise the number of segments as it doesn't
>>> affect the ABI, but it wants a good explanation of what kind of weird
>>> application wants to write to all over memory when it is loaded.
>>
>> kexec can be used to load not only the kernel images, but also more
>> complex images such as hibernation image. So I think it is good to
>> raise the number of segments.
>
> Totally reasonable.
>
> And in all fairness the patch does a good job of raising the limit.
>
> However if that is the goal 1024 is probably a bit low as I believe
> SGI has built machines with that many nodes.  Still after the patch
> under discussion 1024 was only a limit in a header file so it can
> be trivially changed.

So, what is a better number? 2048? :)

Thanks.

-- 
The opposite of love is not hate, it's indifference.
  - Elie Wiesel
