Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab0L1MYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 07:24:07 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46623 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab0L1MYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 07:24:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=X00sseI5X4OC8vCJz5wF4ZhYVmNVoQ2XuW3JgsRH+lPbhLiFGB1VA2onYrRg0m8Rbk
         P/7o2KxgOXIp0/pKoWc6JuQH5yytHcm04X9WlGXswQl+J3VOUqC/sXW11wqW/jF2R5mG
         mNZiE9/MvPozCVy8K5XQvClPibiEX03B6lI8Q=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=ZY09yJ=pK4ejqOZjh7YjJp1UemRdMgMfpsz2f@mail.gmail.com>
References: <1292870624-25450-1-git-send-email-felipe.contreras@nokia.com>
	<AANLkTikisHaAMZphRJVYdcokVbaZXVF9COrwkdGTDg__@mail.gmail.com>
	<AANLkTi=9AL3aWUsMeih+Gb-sMov=MgBZ1eTp8wb=q1hZ@mail.gmail.com>
	<AANLkTinX8t=3b48e2sxPU-V_G-nGm_1DyEg6B-CeqXDa@mail.gmail.com>
	<1293452486-notmuch-felipe.contreras@nokia.com>
	<AANLkTinz0HuhGB_WzTQbK8XkfkGALjtg928WdOUYsySf@mail.gmail.com>
	<AANLkTimCB5g29gzWFzaFU1N8+doROTpWaXy18VU5AJyH@mail.gmail.com>
	<AANLkTi=xmxkWnhuYcjtDNDHgep_2EztfGXDv+winW2Y5@mail.gmail.com>
	<AANLkTiksjHKjKQ+mWE=Zf0+967_E46V3+RURcMC-s5cD@mail.gmail.com>
	<AANLkTi=ZY09yJ=pK4ejqOZjh7YjJp1UemRdMgMfpsz2f@mail.gmail.com>
Date: Tue, 28 Dec 2010 14:24:03 +0200
Message-ID: <AANLkTinZ0Uwp8jbmsSwm6ut75A06CxrkESTRJT-GoPkP@mail.gmail.com>
Subject: Re: [PATCH v2] staging: tidspbridge: protect dmm_map properly
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        greg@kroah.com, omar.ramirez@ti.com, fernando.lugo@ti.com, nm@ti.com,
        ameya.palande@nokia.com, h-kanigeri2@ti.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 2:18 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Tue, Dec 28, 2010 at 2:12 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>> I haven't investigated why that happens, but kernel-space should not
>> panic regardless of what user-space does.
>
> Agree of course. But that's not what we were discussing...

Well, hopefully after applying your patch it would be easier to figure that out.

>>> Anyhow, a thread that is calling proc_*_dma() will both increase the
>>> reference count and decrease it back before going back to user space.
>>> Otherwise your patch would be problematic as well - who will unlock
>>> the mutex you take in proc_*_dma() ?
>>
>> I'm saying that user-space might crash *before* proc_*_dma() finishes,
>> before the reference count has been decreased.
>>
>> In my patch there would be no issue because proc_un_map() would wait
>> until proc_*_dma() has released the lock.
>
> But what will happen if, as you say, user-space would crash before
> proc_*_dma() has released the lock ? how could proc_un_map() run ?

user-space crashed, not kernel-space; the code would continue to run
and eventually release the lock.

> This is all good, and I have no problem with it. As I said, I don't
> resist your patch as a temporary fix. But it doesn't mean I like it...

Yeah, so the chances of getting this fixed on 2.6.37 are dimmed.

-- 
Felipe Contreras
