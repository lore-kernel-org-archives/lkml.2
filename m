Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab2HTFWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 01:22:19 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56611 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2HTFWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 01:22:16 -0400
MIME-Version: 1.0
In-Reply-To: <5031C765.9050107@xenotime.net>
References: <1345242330.3841.8.camel@fedora64.linuxtx.org>
	<502EC5A6.7040502@xenotime.net>
	<CAPM=9tzcmU-uBSaH0jASmp0iCu43fPROefip9mr_Q9qCAMzZEw@mail.gmail.com>
	<CAPM=9ty9UUZKcgp4MijM9CDGyDaD0dWi2z2htPvjMRHbCHRhUw@mail.gmail.com>
	<5031C765.9050107@xenotime.net>
Date: Mon, 20 Aug 2012 15:22:15 +1000
Message-ID: <CAPM=9twHc4i9eOUt3AwW_WQ+K70WvW9qMsOKsOxH-rHHQAd4qQ@mail.gmail.com>
Subject: Re: 3.5.x boot hang after conflicting fb hw usage <driver> vs VESA
 VGA - removing generic driver
From: Dave Airlie <airlied@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: "Justin M. Forbes" <jforbes@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 3:13 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 08/17/12 15:55, Dave Airlie wrote:
>
>> On Sat, Aug 18, 2012 at 8:54 AM, Dave Airlie <airlied@gmail.com> wrote:
>>> On Sat, Aug 18, 2012 at 8:28 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>>>> On 08/17/2012 03:25 PM, Justin M. Forbes wrote:
>>>>
>>>>> for <driver>, we have verified cases on inteldrmfb, radeondrmfb, and
>>>>> cirrusdrmfb.
>>>>>
>>>>> This is the last message displayed before the system hangs.  This seems
>>>>> to be hitting a large number of users in Fedora, though certainly not
>>>>> everyone.  This started happening with the 3.5 updates, and is still an
>>>>> issue.  It appears to be a race condition, because various things have
>>>>> allowed boot to continue for some users, though there is no clear work
>>>>> around. Has anyone else run across this?  Any ideas.  For more
>>>>> background we have the following bugs:
>>>>>
>>>>> inteldrmfb:
>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=843826
>>>>>
>>>>> radeondrmfb:
>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=845745
>>>>>
>>>>> cirrusdrmfb <kvm>:
>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=843860
>>>>>
>>>>> It should be noted that the conflicting fb hw usage message is not new,
>>>>> it has been around for a while, but this is the last message seen before
>>>>> the hang.
>>>>
>>>>
>>>> Hi,  (adding dri-devel mailing list)
>>>>
>>>>
>>>> I started seeing this problem on 3.5-rc6.
>>>>
>>>> AFAICT, the system is not actually hung, it's just that no output
>>>> is showing up on the real (physical) output device (display) -- it's
>>>> going somewhere else (or to the bit bucket).
>>>>
>>>
>>> Can we bisect this at all?
>
> I guess I'll have to try again.  My first attempt did not
> prove anything, I think because the conflict does not happen
> 100% of the time (i.e., it feels like a timing problem).
>
>>> I worry the intel one will bisect to where we moved the conflict
>>> resolution earlier, but I'd like to see if applying that patch earlier
>>> causes the issue, since radeon has it.
>
> Do you know of a specific commit that I could revert and test?

9f846a16d213523fbe6daea17e20df6b8ac5a1e5

might work, but it just changes the timing mostly.

also testing 3.4 with that on top would be good.

Dave.
