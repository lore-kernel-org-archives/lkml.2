Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3AJQVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:21:24 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:55537 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3AJQVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:21:22 -0500
MIME-Version: 1.0
In-Reply-To: <20130110093831.GA19503@liondog.tnic>
References: <20130110093831.GA19503@liondog.tnic>
Date: Thu, 10 Jan 2013 11:21:21 -0500
Message-ID: <CADnq5_N9Dj5ZMoDaL9hp6R5wMkEf2yEL1C=66-PQ2+sLwwTm3g@mail.gmail.com>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
From: Alex Deucher <alexdeucher@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 4:38 AM, Borislav Petkov <bp@alien8.de> wrote:
> [ deliberately breaking the thread because it got too long]
>
> On Sat, Dec 22, 2012 at 09:35:47PM +0100, Borislav Petkov wrote:
>> Hi Alex,
>>
>> got the sickest bug on 3.8-rc1, see below. The GPU locks up somewhere
>> down radeon_fence_wait_seq, judging by the error messages.
>>
>> And this doesn't happen with 3.7, of course.
>>
>> Let me know if you need any more info, thanks.
>>
>> [16273.668350] radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
>> [16273.668361] radeon 0000:02:00.0: GPU lockup (waiting for 0x000000000000002b last fence id 0x000000000000002a)
>> [16273.882550] plugin-containe[11435]: segfault at 7f1f0a66cc08 ip 00007f1f13289bdb sp 00007f1f0a2fe9e0 error 4 in libflashplayer.so[7f1f130c5000+117b000]
>> [16274.502807] ------------[ cut here ]------------
>> [16274.502845] WARNING: at lib/list_debug.c:53 __list_del_entry+0x63/0xd0()
>
> Ok, this got fixed by 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb which is
> upstream now. And I'm testing -rc2+ which contains this patch already
> + tip/master + another fix from Alan which reworks fb console locking
> (should be unrelated) and the machine gets unresponsive for a couple of
> seconds and then it is fine again.
>
> See dmesg below, the GPU gets the same lockup CP stall without the list
> corruption so it recovers fine. But I didn't have those stalls before so
> it has to be something which came up with 3.8 merge window.

I'm assuming you didn't also update your userspace gfx stack?  Does
disabling the new DMA ring for ttm bo moves avoid the issue?

Alex
