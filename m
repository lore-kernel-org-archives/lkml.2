Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0L1MSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 07:18:24 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39965 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab0L1MSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 07:18:23 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.188.89]
In-Reply-To: <AANLkTiksjHKjKQ+mWE=Zf0+967_E46V3+RURcMC-s5cD@mail.gmail.com>
References: <1292870624-25450-1-git-send-email-felipe.contreras@nokia.com>
 <AANLkTikisHaAMZphRJVYdcokVbaZXVF9COrwkdGTDg__@mail.gmail.com>
 <AANLkTi=9AL3aWUsMeih+Gb-sMov=MgBZ1eTp8wb=q1hZ@mail.gmail.com>
 <AANLkTinX8t=3b48e2sxPU-V_G-nGm_1DyEg6B-CeqXDa@mail.gmail.com>
 <1293452486-notmuch-felipe.contreras@nokia.com> <AANLkTinz0HuhGB_WzTQbK8XkfkGALjtg928WdOUYsySf@mail.gmail.com>
 <AANLkTimCB5g29gzWFzaFU1N8+doROTpWaXy18VU5AJyH@mail.gmail.com>
 <AANLkTi=xmxkWnhuYcjtDNDHgep_2EztfGXDv+winW2Y5@mail.gmail.com> <AANLkTiksjHKjKQ+mWE=Zf0+967_E46V3+RURcMC-s5cD@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 28 Dec 2010 14:18:02 +0200
Message-ID: <AANLkTi=ZY09yJ=pK4ejqOZjh7YjJp1UemRdMgMfpsz2f@mail.gmail.com>
Subject: Re: [PATCH v2] staging: tidspbridge: protect dmm_map properly
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        greg@kroah.com, omar.ramirez@ti.com, fernando.lugo@ti.com, nm@ti.com,
        ameya.palande@nokia.com, h-kanigeri2@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 2:12 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> I haven't investigated why that happens, but kernel-space should not
> panic regardless of what user-space does.

Agree of course. But that's not what we were discussing...

>> Anyhow, a thread that is calling proc_*_dma() will both increase the
>> reference count and decrease it back before going back to user space.
>> Otherwise your patch would be problematic as well - who will unlock
>> the mutex you take in proc_*_dma() ?
>
> I'm saying that user-space might crash *before* proc_*_dma() finishes,
> before the reference count has been decreased.
>
> In my patch there would be no issue because proc_un_map() would wait
> until proc_*_dma() has released the lock.

But what will happen if, as you say, user-space would crash before
proc_*_dma() has released the lock ? how could proc_un_map() run ?

> Because:
>  1) Your patch changes 114 lines, mine 18
>  2) It hasn't been reviewed, nor tested by other people
>  3) At least I see a potential issue
>  4) 2.6.37 is imminent
>
> IMO one patch has chances going into 2.6.37, the other one doesn't. I
> don't see the problem of pushing my patch to 2.6.37, and once your
> patch has been properly reviewed, and tested, put it for the 2.6.38
> merge window. Anyway, it's looking more and more that this patch would
> not be ack'ed in time, so I guess we would have to wait to see what
> other people (Omar?) say, which would probably be 2.6.38 timeline.

This is all good, and I have no problem with it. As I said, I don't
resist your patch as a temporary fix. But it doesn't mean I like it...
