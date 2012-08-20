Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab2HTFNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 01:13:16 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:35890 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754369Ab2HTFNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 01:13:13 -0400
Message-ID: <5031C765.9050107@xenotime.net>
Date: Sun, 19 Aug 2012 22:13:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: "Justin M. Forbes" <jforbes@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org, dri-devel@lists.freedesktop.org
Subject: Re: 3.5.x boot hang after conflicting fb hw usage <driver> vs VESA
 VGA - removing generic driver
References: <1345242330.3841.8.camel@fedora64.linuxtx.org>	<502EC5A6.7040502@xenotime.net>	<CAPM=9tzcmU-uBSaH0jASmp0iCu43fPROefip9mr_Q9qCAMzZEw@mail.gmail.com> <CAPM=9ty9UUZKcgp4MijM9CDGyDaD0dWi2z2htPvjMRHbCHRhUw@mail.gmail.com>
In-Reply-To: <CAPM=9ty9UUZKcgp4MijM9CDGyDaD0dWi2z2htPvjMRHbCHRhUw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/12 15:55, Dave Airlie wrote:

> On Sat, Aug 18, 2012 at 8:54 AM, Dave Airlie <airlied@gmail.com> wrote:
>> On Sat, Aug 18, 2012 at 8:28 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>>> On 08/17/2012 03:25 PM, Justin M. Forbes wrote:
>>>
>>>> for <driver>, we have verified cases on inteldrmfb, radeondrmfb, and
>>>> cirrusdrmfb.
>>>>
>>>> This is the last message displayed before the system hangs.  This seems
>>>> to be hitting a large number of users in Fedora, though certainly not
>>>> everyone.  This started happening with the 3.5 updates, and is still an
>>>> issue.  It appears to be a race condition, because various things have
>>>> allowed boot to continue for some users, though there is no clear work
>>>> around. Has anyone else run across this?  Any ideas.  For more
>>>> background we have the following bugs:
>>>>
>>>> inteldrmfb:
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=843826
>>>>
>>>> radeondrmfb:
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=845745
>>>>
>>>> cirrusdrmfb <kvm>:
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=843860
>>>>
>>>> It should be noted that the conflicting fb hw usage message is not new,
>>>> it has been around for a while, but this is the last message seen before
>>>> the hang.
>>>
>>>
>>> Hi,  (adding dri-devel mailing list)
>>>
>>>
>>> I started seeing this problem on 3.5-rc6.
>>>
>>> AFAICT, the system is not actually hung, it's just that no output
>>> is showing up on the real (physical) output device (display) -- it's
>>> going somewhere else (or to the bit bucket).
>>>
>>
>> Can we bisect this at all?

I guess I'll have to try again.  My first attempt did not
prove anything, I think because the conflict does not happen
100% of the time (i.e., it feels like a timing problem).

>> I worry the intel one will bisect to where we moved the conflict
>> resolution earlier, but I'd like to see if applying that patch earlier
>> causes the issue, since radeon has it.

Do you know of a specific commit that I could revert and test?

>> I haven't reproduced this on any hw I own, I also can't get it under qemu.
> 
> I'm also wondering whether this grub2 related in some way, grub2 is
> starting to mess with the graphics adapter pointlessly.
> 
> Dave.



-- 
~Randy
