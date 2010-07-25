Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab0GYCyb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 22:54:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42990 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0GYCy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 22:54:29 -0400
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        nhorman@redhat.com, akpm@linux-foundation.org
Subject: Re: [Patch] kexec: increase max of kexec segments and use dynamic  allocation
References: <20100722061810.5659.87609.sendpatchset@localhost.localdomain>
	<m1wrso2foi.fsf@fess.ebiederm.org> <4C47E7C9.60608@redhat.com>
	<m1iq482duy.fsf@fess.ebiederm.org>
	<AANLkTikZTGYl2NIFzcTCG2DAaMefhnJAkSHIoJN22QoI@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 24 Jul 2010 19:54:22 -0700
In-Reply-To: <AANLkTikZTGYl2NIFzcTCG2DAaMefhnJAkSHIoJN22QoI@mail.gmail.com> (huang ying's message of "Fri\, 23 Jul 2010 10\:57\:33 +0800")
Message-ID: <m1lj90p8yp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

huang ying <huang.ying.caritas@gmail.com> writes:

> On Thu, Jul 22, 2010 at 3:08 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Cong Wang <amwang@redhat.com> writes:
>>
>>> On 07/22/10 14:28, Eric W. Biederman wrote:
>>>> Amerigo Wang<amwang@redhat.com>  writes:
>>>>
>>>>> Currently KEXEC_SEGMENT_MAX is only 16 which is too small for machine with
>>>>> many memory ranges. Increase this hard limit to 1024 which is reasonably large,
>>>>> and change ->segment from a static array to a dynamically allocated memory.
>>>>
>>>> ???
>>>>
>>>> This should be about segments in the executable being loaded.  What
>>>> executable has one segment for each range of physical memory?
>>>>
>>>> Not that generalizing this is a bad idea but with a comment that
>>>> seems entirely wrong I am wondering what the problem really is.
>>>>
>>>
>>> Ah, I think Neil should explain this.
>>>
>>> He made a patch which includes many memory ranges, caused kexec
>>> fails to load the kernel. Increasing this limit and the corresponding
>>> one in kexec-tools fixes the problem. His patch is not in upstream
>>> kexec-tools, AFAIK.
>>>
>>> However, even if we don't consider that patch, isn't 16 too small too?
>>
>> Generally you just need one physical hunk for the code, maybe a second
>> for the initrd.
>>
>> It is perfectly fine to raise the number of segments as it doesn't
>> affect the ABI, but it wants a good explanation of what kind of weird
>> application wants to write to all over memory when it is loaded.
>
> kexec can be used to load not only the kernel images, but also more
> complex images such as hibernation image. So I think it is good to
> raise the number of segments.

Totally reasonable.

And in all fairness the patch does a good job of raising the limit.

However if that is the goal 1024 is probably a bit low as I believe
SGI has built machines with that many nodes.  Still after the patch
under discussion 1024 was only a limit in a header file so it can
be trivially changed.

Eric
