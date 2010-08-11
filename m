Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab0HKU4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 16:56:16 -0400
Received: from vs244178.vserver.de ([62.75.244.178]:33655 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191Ab0HKU4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 16:56:15 -0400
Date: Wed, 11 Aug 2010 22:56:09 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1718769257.20100811225609@eikelenboom.it>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pete Eberlein <pete@sensoray.com>, <mrechberger@gmail.com>,
        <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [2.6.35] usb 2.0 em28xx kernel panic general protection fault:  0000 [#1] SMP RIP: 0010:[<ffffffffa004fbc5>] [<ffffffffa004fbc5>]  em28xx_isoc_copy_vbi+0x62e/0x812 [em28xx]
In-Reply-To: <AANLkTin7JxN81tpM+=rmN6jjnOBkd6c+Cy9tx5vruSZ7@mail.gmail.com>
References: <61936849.20100811001257@eikelenboom.it> <AANLkTinVNms-vdfG-VZzkOadogaCRV+HyDAY5yhYOJSK@mail.gmail.com> <1117369508.20100811005719@eikelenboom.it> <AANLkTikPffMQLXcPF4-xPeZfkaAtnu7xEP0TMzYVrkgE@mail.gmail.com> <1843123111.20100811092547@eikelenboom.it> <1281542325.2360.86.camel@pete-desktop> <4C62D3EE.5000907@infradead.org> <AANLkTin7JxN81tpM+=rmN6jjnOBkd6c+Cy9tx5vruSZ7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Devin,

Yes i can confirm it was my mistake, with video4linux2 it works.

--
Sander

Wednesday, August 11, 2010, 8:31:56 PM, you wrote:

> On Wed, Aug 11, 2010 at 12:46 PM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
>> Em 11-08-2010 12:58, Pete Eberlein escreveu:
>>> On Wed, 2010-08-11 at 09:25 +0200, Sander Eikelenboom wrote:
>>>> Hello Devin,
>>>>
>>>> Yes it's completely reproducible for a change:
>>>>
>>>> ffmpeg -f video4linux -r 25 -s 720x576 -i /dev/video0 out.flv
>>>> gave an error:
>>>
>>> Use -f video4linux2.
>>>
>>> The -f video4linux option uses the old video4linux1 API.  I have seen
>>> similar strange behavior when I used that ffmpeg option with a v4l2
>>> driver I am developing.  Also, ffmpeg does not use libv4l.
>>
>> Still, we have a bug to fix. The driver shouldn't generating a PANIC if accessed
>> via V4L1 API.

> I agree with Mauro completely.  There is nothing userland should be
> able to do which results in a panic (and I have no reason to believe
> Pete was suggesting otherwise).  That said, it's really useful to know
> that this is some sort of v4l1 backward compatibility problem.

> I'll see if I can reproduce this here.

> Thanks,

> Devin




-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it

