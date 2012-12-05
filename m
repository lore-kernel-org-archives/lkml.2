Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2LELfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:35:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab2LELf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:35:29 -0500
Message-ID: <50BF315C.8090203@redhat.com>
Date: Wed, 05 Dec 2012 09:34:52 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Federico Vaga <federico.vaga@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3 3/4] sta2x11_vip: convert to videobuf2 and control
 framework
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com> <1348484332-8106-3-git-send-email-federico.vaga@gmail.com> <50BE2193.4020103@redhat.com> <8113379.Pqy1l62Utl@number-5>
In-Reply-To: <8113379.Pqy1l62Utl@number-5>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Federico,

Em 04-12-2012 23:12, Federico Vaga escreveu:
> On Tuesday 04 December 2012 14:15:15 Mauro Carvalho Chehab wrote:
>> Em 24-09-2012 07:58, Federico Vaga escreveu:
>>> This patch re-write the driver and use the videobuf2
>>> interface instead of the old videobuf. Moreover, it uses also
>>> the control framework which allows the driver to inherit
>>> controls from its subdevice (ADV7180)
>>>
>>> Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
>>> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
>>>
>>> [..........]
>>>
>>>    /*
>>>
>>>     * This is the driver for the STA2x11 Video Input Port.
>>>     *
>>>
>>> + * Copyright (C) 2012       ST Microelectronics
>>>
>>>     * Copyright (C) 2010       WindRiver Systems, Inc.
>>>     *
>>>     * This program is free software; you can redistribute it and/or modify
>>>     it
>>>
>>> @@ -19,36 +20,30 @@
>>>
>>>     * The full GNU General Public License is included in this distribution
>>>     in
>>>     * the file called "COPYING".
>>>     *
>>>
>>> - * Author: Andreas Kies <andreas.kies@windriver.com>
>>> - *		Vlad Lungu <vlad.lungu@windriver.com>
>>
>> Why are you dropping those authorship data?
>>
>> Ok, it is clear to me that most of the code there got rewritten, and,
>> while IANAL, I think they still have some copyrights on it.
>>
>> So, if you're willing to do that, you need to get authors ack
>> on such patch.
>
> I re-write the driver, and also the first version of the driver has many
> modification made by me, many bug fix, style review, remove useless code.
> The first time I didn't add myself as author because the logic of the driver
> did not change. This time, plus the old change I think there is nothing of the
> original driver because I rewrite it from the hardware manual. Practically, It
> is a new driver for the same device.

Yeah, there are many changes there that justifies adding you at its
authorship, and that's ok. Also, anyone saying the size of your patch
will recognize your and ST efforts to improve the driver.

However, as some parts of the code were preserved, dropping the old
authors doesn't sound right (and can even be illegal, in the light
of the GPL license). It would be ok, though, if you would be
changing it to something like:

	Copyright (c) 2010 by ...
or
	Original driver from ...

or some other similar wording that would preserve their names
there. We do that even when something is rewritten, like, for
example, drivers/media/v4l2-core/videobuf-core.c:

  * (c) 2007 Mauro Carvalho Chehab, <mchehab@infradead.org>
  *
  * Highly based on video-buf written originally by:
  * (c) 2001,02 Gerd Knorr <kraxel@bytesex.org>
  * (c) 2006 Mauro Carvalho Chehab, <mchehab@infradead.org>
  * (c) 2006 Ted Walther and John Sokol

>
> Anyway I will try to contact the original authors for the acked-by.
>
>>>    MODULE_DESCRIPTION("STA2X11 Video Input Port driver");
>>>
>>> -MODULE_AUTHOR("Wind River");
>>
>> Same note applies here: we need Wind River's ack on that to drop it.
>
> I will try also for this. But I think that this is not a windriver driver
> because I re-wrote it from the hardware manual. I used the old driver because
> I thought that it was better than propose a patch that remove the old driver
> and add my driver.
> I did not remove the 2010 Copyright from windriver, because they did the job,
> but this work was paid by ST (copyright 2012) and made completely by me.

The same reason why you didn't drop windriver's copyright also applies here:
while most of the code changed, there are still a few things left from the
original driver.

> Is my thinking wrong?
>
> Just a question for the future so I avoid to redo the same error. If I re-
> wrote most of a driver I cannot change the authorship automatically without
> the acked-by of the previous author. If I ask to the previous author and he
> does not give me the acked-by (or he is unreachable, he change email address),
> then the driver is written by me but the author is someone else? Right? So, it
> is better if I propose a patch which remove a driver and a patch which add my
> driver?

The only way of not preserving the original authors here were if you
start from scratch, without looking at the original code (and you can
somehow, be able to proof it), otherwise, the code will be fit as a
"derivative work", in the light of GPL, and should be preserving the
original authorship.

Something started from scratch like that will hardly be accepted upstream,
as regressions will likely be introduced, and previously supported
hardware/features may be lost in the process.

Of course the original author can abdicate to his rights of keeping his
name on it. Yet, even if he opt/accept to not keep his name explicitly
there, his copyrights are preserved, with the help of the git history.

That's said, no single kernel developer/company has full copyrights on
any part of the Kernel, as their code are based on someone else's work.
For example, all Kernel drivers depend on drivers/base, with in turn,
depends on memory management, generic helper functions, arch code, etc.

So, IMHO, there's not much point on dropping authorship messages.

Regards,
Mauro
