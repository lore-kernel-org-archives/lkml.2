Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab0GWC5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 22:57:37 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35953 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab0GWC5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 22:57:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vMu/Xp2W3oH1T272X3slJOpTvkQ+H57oyWc1CDdyAgCpo0t4K88uxULhwZOvSamstf
         2qPsqOJwfUmfhq/+xeupeZKbcKrOqCPPf8yu/BwHHsXVOP5jaNqQxwjEBT7I2x3fgKL2
         QGaa9oEJCGQaammAXI3KxAXszmy/WBHYyw9zM=
MIME-Version: 1.0
In-Reply-To: <m1iq482duy.fsf@fess.ebiederm.org>
References: <20100722061810.5659.87609.sendpatchset@localhost.localdomain>
	<m1wrso2foi.fsf@fess.ebiederm.org>
	<4C47E7C9.60608@redhat.com>
	<m1iq482duy.fsf@fess.ebiederm.org>
Date: Fri, 23 Jul 2010 10:57:33 +0800
Message-ID: <AANLkTikZTGYl2NIFzcTCG2DAaMefhnJAkSHIoJN22QoI@mail.gmail.com>
Subject: Re: [Patch] kexec: increase max of kexec segments and use dynamic 
	allocation
From: huang ying <huang.ying.caritas@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        nhorman@redhat.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 3:08 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Cong Wang <amwang@redhat.com> writes:
>
>> On 07/22/10 14:28, Eric W. Biederman wrote:
>>> Amerigo Wang<amwang@redhat.com>  writes:
>>>
>>>> Currently KEXEC_SEGMENT_MAX is only 16 which is too small for machine with
>>>> many memory ranges. Increase this hard limit to 1024 which is reasonably large,
>>>> and change ->segment from a static array to a dynamically allocated memory.
>>>
>>> ???
>>>
>>> This should be about segments in the executable being loaded.  What
>>> executable has one segment for each range of physical memory?
>>>
>>> Not that generalizing this is a bad idea but with a comment that
>>> seems entirely wrong I am wondering what the problem really is.
>>>
>>
>> Ah, I think Neil should explain this.
>>
>> He made a patch which includes many memory ranges, caused kexec
>> fails to load the kernel. Increasing this limit and the corresponding
>> one in kexec-tools fixes the problem. His patch is not in upstream
>> kexec-tools, AFAIK.
>>
>> However, even if we don't consider that patch, isn't 16 too small too?
>
> Generally you just need one physical hunk for the code, maybe a second
> for the initrd.
>
> It is perfectly fine to raise the number of segments as it doesn't
> affect the ABI, but it wants a good explanation of what kind of weird
> application wants to write to all over memory when it is loaded.

kexec can be used to load not only the kernel images, but also more
complex images such as hibernation image. So I think it is good to
raise the number of segments.

Best Regards,
Huang Ying
