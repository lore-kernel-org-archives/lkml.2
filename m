Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab0K2TIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:08:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49292 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab0K2TIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:08:00 -0500
Message-ID: <4CF3F996.4090703@zytor.com>
Date: Mon, 29 Nov 2010 11:05:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@linux-foundation.org, w@1wt.eu,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
References: <20101116104600.GA24015@suse.de> <20101119191906.GA31760@xanatos> <AANLkTi=OsWEdrfCOHKz+SAtqo7DmK0nNxku7Ev21f0Lh@mail.gmail.com> <20101126074809.GD19589@elte.hu> <20101129163308.GA2383@xanatos> <20101129180429.GB14046@elte.hu>
In-Reply-To: <20101129180429.GB14046@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 10:04 AM, Ingo Molnar wrote:
> 
> * Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
> 
>> On Fri, Nov 26, 2010 at 08:48:09AM +0100, Ingo Molnar wrote:
>>>
>>> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>
>>>> On Fri, Nov 19, 2010 at 11:19 AM, Sarah Sharp
>>>> <sarah.a.sharp@linux.intel.com> wrote:
>>>>>
>>>>> .config and dmesg are attached.  The box is running klogd 1.5.5ubuntu3
>>>>> (from Jaunty).  Yes, I know that's old.  I read the bit in the commit
>>>>> about changing the permissions of kallsyms after boot, but if I can't
>>>>> boot that doesn't help.  Perhaps this can be made a configuration
>>>>> option?
>>>>
>>>> It's not worth a config option.
>>>>
>>>> If it actually breaks user-space, I think we should just revert it.
>>>
>>> Sarah,
>>>
>>> Does your system boot fine if we make /proc/kallsyms simply an empty file to 
>>> unprivileged users? Something like the (untested ...) patch below.
>>
>> Yes, that works.  The system boots as normal. `cat /proc/kallsyms`
>> returns an empty file, and `sudo cat /proc/kallsyms` does not.
> 
> Great! Marcus, mind respinning your patch with that approach?
> 

Can we please not use CAP_SYS_ADMIN for this?  Relying on CAP_SYS_ADMIN
is worse than anything else -- it is a fixed policy hardcoded in the
kernel, with no ability for the system owner to delegate the policy
outward, e.g. by adding group read permission and/or chgrp the file.

Delegating CAP_SYS_ADMIN, of course, otherwise known as "everything", is
worse than anything...
	
	-hpa
