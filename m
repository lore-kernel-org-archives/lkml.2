Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab1BSLfP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 06:35:15 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57088 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1BSLfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 06:35:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uq1DIw/NHvj+DeZkOUsSwxsMqipTX1fbLxpaGEG2M3qrG5Kv4beKSgOZnrP3BQhMIP
         32aYQlHuw01rmSZYXCQiT7OcvyLg91tzjVc0fSRiMbQbb3VVNHQiBCoWkhbWXlDu8bji
         +NiVqpGg5RvYpg8r4bUzGd19Vc6OJWiVLF2I8=
MIME-Version: 1.0
In-Reply-To: <4D5A6EEC.5000908@maxwell.research.nokia.com>
References: <1297068547-10635-1-git-send-email-weber@corscience.de>
	<4D5A6353.7040907@maxwell.research.nokia.com>
	<20110215113717.GN2570@legolas.emea.dhcp.ti.com>
	<4D5A672A.7040000@samsung.com>
	<4D5A6874.1080705@corscience.de>
	<20110215115349.GQ2570@legolas.emea.dhcp.ti.com>
	<4D5A6EEC.5000908@maxwell.research.nokia.com>
Date: Sat, 19 Feb 2011 13:35:09 +0200
Message-ID: <AANLkTik+6fguqgH8Bpnpqo7Axmquy3caRMELTZVmuN1j@mail.gmail.com>
Subject: Re: [PATCH resend] video: omap24xxcam: Fix compilation
From: David Cohen <dacohen@gmail.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>, balbi@ti.com
Cc: Thomas Weber <weber@corscience.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-omap@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, Tejun Heo <tj@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari and Felipe,

On Tue, Feb 15, 2011 at 2:17 PM, Sakari Ailus
<sakari.ailus@maxwell.research.nokia.com> wrote:
> Felipe Balbi wrote:
>> Hi,
>>
>> On Tue, Feb 15, 2011 at 12:50:12PM +0100, Thomas Weber wrote:
>>> Hello Felipe,
>>>
>>> in include/linux/wait.h
>>>
>>> #define wake_up(x)            __wake_up(x, TASK_NORMAL, 1, NULL)
>>
>> aha, now I get it, so shouldn't the real fix be including <linux/sched.h>
>> on <linux/wait.h>, I mean, it's <linuux/wait.h> who uses a symbol
>> defined in <linux/sched.h>, right ?

That's a tricky situation. linux/sched.h includes indirectly
linux/completion.h which includes linux/wait.h.
By including sched.h in wait.h, the side effect is completion.h will
then include a blank wait.h file and trigger a compilation error every
time wait.h is included by any file.

>
> Surprisingly many other files still don't seem to be affected. But this
> is actually a better solution (to include sched.h in wait.h).

It does not affect all files include wait.h because TASK_* macros are
used with #define statements only. So it has no effect unless some
file tries to use a macro which used TASK_*. It seems the usual on
kernel is to include both wait.h and sched.h when necessary.
IMO your patch is fine.

Br,

David

>
> --
> Sakari Ailus
> sakari.ailus@maxwell.research.nokia.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
