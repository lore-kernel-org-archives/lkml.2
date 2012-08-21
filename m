Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab2HUA6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 20:58:41 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:60234 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753530Ab2HUA6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 20:58:38 -0400
Message-ID: <5032DD3A.9030100@xenotime.net>
Date: Mon, 20 Aug 2012 17:58:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: "Justin M. Forbes" <jforbes@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org, dri-devel@lists.freedesktop.org
Subject: Re: 3.5.x boot hang after conflicting fb hw usage <driver> vs VESA
 VGA - removing generic driver
References: <1345242330.3841.8.camel@fedora64.linuxtx.org>	<502EC5A6.7040502@xenotime.net>	<CAPM=9tzcmU-uBSaH0jASmp0iCu43fPROefip9mr_Q9qCAMzZEw@mail.gmail.com>	<CAPM=9ty9UUZKcgp4MijM9CDGyDaD0dWi2z2htPvjMRHbCHRhUw@mail.gmail.com>	<5031C765.9050107@xenotime.net>	<CAPM=9twHc4i9eOUt3AwW_WQ+K70WvW9qMsOKsOxH-rHHQAd4qQ@mail.gmail.com>	<5032BDF5.1060800@xenotime.net> <CAPM=9twjpx8kYggKW+ZG39eSzr=Q2nFt2xPKVk5od2HUAexmNw@mail.gmail.com>
In-Reply-To: <CAPM=9twjpx8kYggKW+ZG39eSzr=Q2nFt2xPKVk5od2HUAexmNw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 05:23 PM, Dave Airlie wrote:

> On Tue, Aug 21, 2012 at 8:45 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> On 08/19/2012 10:22 PM, Dave Airlie wrote:
>>
>>> On Mon, Aug 20, 2012 at 3:13 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>>>> On 08/17/12 15:55, Dave Airlie wrote:
>>>>
>>>>> On Sat, Aug 18, 2012 at 8:54 AM, Dave Airlie <airlied@gmail.com> wrote:
>>>>>> On Sat, Aug 18, 2012 at 8:28 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>>>>>>> On 08/17/2012 03:25 PM, Justin M. Forbes wrote:
>>>>>>>
>>>>>>>> for <driver>, we have verified cases on inteldrmfb, radeondrmfb, and
>>>>>>>> cirrusdrmfb.
>>>>>>>>
>>>>>>>> This is the last message displayed before the system hangs.  This seems
>>>>>>>> to be hitting a large number of users in Fedora, though certainly not
>>>>>>>> everyone.  This started happening with the 3.5 updates, and is still an
>>>>>>>> issue.  It appears to be a race condition, because various things have
>>>>>>>> allowed boot to continue for some users, though there is no clear work
>>>>>>>> around. Has anyone else run across this?  Any ideas.  For more
>>>>>>>> background we have the following bugs:
>>>>>>>>
>>>>>>>> inteldrmfb:
>>>>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=843826
>>>>>>>>
>>>>>>>> radeondrmfb:
>>>>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=845745
>>>>>>>>
>>>>>>>> cirrusdrmfb <kvm>:
>>>>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=843860
>>>>>>>>
>>>>>>>> It should be noted that the conflicting fb hw usage message is not new,
>>>>>>>> it has been around for a while, but this is the last message seen before
>>>>>>>> the hang.
>>>>>>>
>>>>>>>
>>>>>>> Hi,  (adding dri-devel mailing list)
>>>>>>>
>>>>>>>
>>>>>>> I started seeing this problem on 3.5-rc6.
>>>>>>>
>>>>>>> AFAICT, the system is not actually hung, it's just that no output
>>>>>>> is showing up on the real (physical) output device (display) -- it's
>>>>>>> going somewhere else (or to the bit bucket).
>>>>>>>
>>>>>>
>>>>>> Can we bisect this at all?
>>>>
>>>> I guess I'll have to try again.  My first attempt did not
>>>> prove anything, I think because the conflict does not happen
>>>> 100% of the time (i.e., it feels like a timing problem).
>>>>
>>>>>> I worry the intel one will bisect to where we moved the conflict
>>>>>> resolution earlier, but I'd like to see if applying that patch earlier
>>>>>> causes the issue, since radeon has it.
>>>>
>>>> Do you know of a specific commit that I could revert and test?
>>>
>>> 9f846a16d213523fbe6daea17e20df6b8ac5a1e5
>>>
>>> might work, but it just changes the timing mostly.
>>>
>>> also testing 3.4 with that on top would be good.
>>
>>
>> That commit doesn't apply cleanly to 3.4, but reverting
>> it on 3.5-rc6 (where I first saw the problem) allows me to boot
>> 3.5-rc6 multiple times without a problem.
>>
>> Maybe Justin can get more stable testing done also..
> 
> Randy do you have a vga= on your kernel command line?


Ah, yes:  "vga=ask"

-- 
~Randy
