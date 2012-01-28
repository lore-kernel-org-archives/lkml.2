Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab2A1KUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 05:20:39 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51298 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331Ab2A1KUh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 05:20:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAPVoSvQhnJC-7UGuggcUOLUcWD1nYOw5yhQzpO-bW0+AAWqYOg@mail.gmail.com>
References: <CAPVoSvSXMvRb=1itu9DjF+s=6zfAChvUxS-x=b8EV9kOZinNpA@mail.gmail.com>
	<20120123165752.GA1980@homer.localdomain>
	<CAPVoSvQYaCC9WcYBeZJtQ++DQhq4QCS8D=nChNjhVNKUHefYdg@mail.gmail.com>
	<CAPVoSvQhnJC-7UGuggcUOLUcWD1nYOw5yhQzpO-bW0+AAWqYOg@mail.gmail.com>
Date: Sat, 28 Jan 2012 11:20:34 +0100
Message-ID: <CAPVoSvT-skg=qnFozn5W+ymKz-2Ls1dPDocGMFU5oW-HpmP3VQ@mail.gmail.com>
Subject: Re: [3.3-rc1]radeon 0000:07:00.0: GPU lockup CP stall for more than 10000msec
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 8:34 AM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
> On Mon, Jan 23, 2012 at 7:01 PM, Torsten Kaiser
> <just.for.lkml@googlemail.com> wrote:
>> On Mon, Jan 23, 2012 at 5:57 PM, Jerome Glisse <j.glisse@gmail.com> wrote:
>>> On Sat, Jan 21, 2012 at 08:03:37PM +0100, Torsten Kaiser wrote:
>>>> After updating to kernel 3.3-rc1 I have experienced a lockup of my GPU.
>>>> I left my KDE desktop running until the screensaver turned off the
>>>> monitors. But on key presses it would not turn back on. Ctrl+Alt+F1 to
>>>> switch to another virtual console also did not work.
>>>> Alt+SysRq magic still worked, so I was able to force the syslog to
>>>> disk and restart the system.
>>>>
>>>
>>> Can you test if attached patch help your case ?
>>
>> Patch is installed, but I can't reproduce the hang on demand.
>> It did happen a second time yesterday while letting the screensaver
>> kick in, but only at around the third or fourth try. Just using "xset
>> dpms force standby/suspend/off" did not trigger it.
>
> I think the patch did what it was intended to do, but it did not really help.
> While the GPU reset did seem to work, X still got stuck and was not
> able to turn the monitors back on.
>
> From the log:
> The GPU lockup happend while the system was idle:
> Jan 23 23:53:54 thoregon kernel: [17121.080129] radeon 0000:07:00.0:
> GPU lockup CP stall for more than 10000msec
> Jan 23 23:53:54 thoregon kernel: [17121.080137] GPU lockup (waiting
> for 0x002080B7 last fence id 0x002080B6)
> Jan 23 23:53:54 thoregon kernel: [17121.096334] radeon 0000:07:00.0:
> GPU softreset
> Jan 23 23:53:54 thoregon kernel: [17121.096341] radeon 0000:07:00.0:
> R_008010_GRBM_STATUS=0xA0003028
> Jan 23 23:53:54 thoregon kernel: [17121.096346] radeon 0000:07:00.0:
> R_008014_GRBM_STATUS2=0x00000002
> Jan 23 23:53:54 thoregon kernel: [17121.096351] radeon 0000:07:00.0:
> R_000E50_SRBM_STATUS=0x200000C0
> Jan 23 23:53:54 thoregon kernel: [17121.096362] radeon 0000:07:00.0:
> R_008020_GRBM_SOFT_RESET=0x00007FEE
> Jan 23 23:53:54 thoregon kernel: [17121.111386] radeon 0000:07:00.0:
> R_008020_GRBM_SOFT_RESET=0x00000001
> Jan 23 23:53:54 thoregon kernel: [17121.127378] radeon 0000:07:00.0:
> R_008010_GRBM_STATUS=0x00003028
> Jan 23 23:53:54 thoregon kernel: [17121.127384] radeon 0000:07:00.0:
> R_008014_GRBM_STATUS2=0x00000002
> Jan 23 23:53:54 thoregon kernel: [17121.127390] radeon 0000:07:00.0:
> R_000E50_SRBM_STATUS=0x200000C0
> Jan 23 23:53:54 thoregon kernel: [17121.128393] radeon 0000:07:00.0:
> GPU reset succeed
> Jan 23 23:53:54 thoregon kernel: [17121.133330] [drm] PCIE GART of
> 512M enabled (table at 0x0000000000040000).
> Jan 23 23:53:54 thoregon kernel: [17121.133364] radeon 0000:07:00.0: WB enabled
> Jan 23 23:53:54 thoregon kernel: [17121.133370] [drm] fence driver on
> ring 0 use gpu addr 0x20000c00 and cpu addr 0xffff8803286e5c00
> Jan 23 23:53:54 thoregon kernel: [17121.179627] [drm] ring test on 0
> succeeded in 1 usecs
> Jan 23 23:53:54 thoregon kernel: [17121.179653] [drm] ib test on ring
> 0 succeeded in 1 usecs

I found the commit (in xf86-video-ati) that causes the lockups and
filed a bug at the xorg bugzilla about it:
https://bugs.freedesktop.org/show_bug.cgi?id=45329

But that still leaves the regression in 3.3-rc1 that even with Jeromes
patch the X server is no longer able to recover from the lockup, as
shown by the SysRq+W trace below.

> There where no messages about X getting stuck ("blocked for more than
> 120 seconds"), but after trying to access the system and failing
> SysRq+W reported this:
> Jan 24 08:08:20 thoregon kernel: [46786.741180] SysRq : Show Blocked State
> Jan 24 08:08:20 thoregon kernel: [46786.741190]   task
>       PC stack   pid father
> Jan 24 08:08:20 thoregon kernel: [46786.741270] X               D
> ffff880337d50a00     0  3047   3026 0x00400004
> Jan 24 08:08:20 thoregon kernel: [46786.741281]  ffff880327eacac0
> 0000000000000086 ffff880327d52e00 0000000000010a00
> Jan 24 08:08:20 thoregon kernel: [46786.741292]  ffff88031be9bfd8
> 0000000000010a00 ffff88031be9a000 ffff88031be9bfd8
> Jan 24 08:08:20 thoregon kernel: [46786.741301]  0000000000010a00
> ffff880327eacac0 0000000000010a00 0000000000010a00
> Jan 24 08:08:20 thoregon kernel: [46786.741310] Call Trace:
> Jan 24 08:08:20 thoregon kernel: [46786.741326]  [<ffffffff815ee9f7>]
> ? schedule_timeout+0x157/0x220
> Jan 24 08:08:20 thoregon kernel: [46786.741336]  [<ffffffff8103fbd0>]
> ? run_timer_softirq+0x240/0x240
> Jan 24 08:08:20 thoregon kernel: [46786.741346]  [<ffffffff8133ee39>]
> ? radeon_fence_wait+0x239/0x3b0
> Jan 24 08:08:20 thoregon kernel: [46786.741356]  [<ffffffff8104f340>]
> ? wake_up_bit+0x40/0x40
> Jan 24 08:08:20 thoregon kernel: [46786.741364]  [<ffffffff81352e07>]
> ? radeon_ib_get+0x257/0x2e0
> Jan 24 08:08:20 thoregon kernel: [46786.741372]  [<ffffffff81354d7a>]
> ? radeon_cs_ioctl+0x27a/0x4d0
> Jan 24 08:08:20 thoregon kernel: [46786.741381]  [<ffffffff812f42d4>]
> ? drm_ioctl+0x3e4/0x490
> Jan 24 08:08:20 thoregon kernel: [46786.741389]  [<ffffffff81354b00>]
> ? radeon_cs_finish_pages+0xa0/0xa0
> Jan 24 08:08:20 thoregon kernel: [46786.741398]  [<ffffffff81024769>]
> ? do_page_fault+0x199/0x420
> Jan 24 08:08:20 thoregon kernel: [46786.741406]  [<ffffffff810af30c>]
> ? mmap_region+0x1dc/0x570
> Jan 24 08:08:20 thoregon kernel: [46786.741414]  [<ffffffff810de446>]
> ? do_vfs_ioctl+0x96/0x4e0
> Jan 24 08:08:20 thoregon kernel: [46786.741422]  [<ffffffff810de8d9>]
> ? sys_ioctl+0x49/0x90
> Jan 24 08:08:20 thoregon kernel: [46786.741430]  [<ffffffff815f1922>]
> ? system_call_fastpath+0x16/0x1b
>
> I did search my logs for more GPU lockups after noting that this also
> happened with 3.2.
> The first lockup in my logs occurred on Nov 4 under 3.1. But until
> 3.3-rc1 X always was able to resume normal operations.
>
> My best guess for the cause of the GPU lockups seems to be the upgrade
> from xf86-video-ati-6.14.2 to 6.14.3, but 3.3-rc1 seems to have an
> independent bug that prevents X to recover from a GPU lockup/reset.
>
>>> Of course it would be best if we did not lockup in the first place.
>>
>> Not sure if this is important: I also upgraded to mesa 8.0-rc1 before
>> the first hang, but after switching back to 3.2 but still using mesa
>> 8.0 I did not have any problems.
>> Except the KDE desktop effects there should not have been any OpenGL
>> programs running.
>> The screen saver itself is just turning the screens off via the KDE
>> power profile.
>>
>> I will report again, when I succeeded in triggering the GPU lockup again...
>>
>> Torsten
