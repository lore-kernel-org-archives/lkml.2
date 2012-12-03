Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2LCCkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 21:40:55 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64765 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab2LCCky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 21:40:54 -0500
MIME-Version: 1.0
In-Reply-To: <87r4nc18i1.fsf@free.fr>
References: <1354155670-6267-1-git-send-email-chao.xie@marvell.com>
	<1354155670-6267-2-git-send-email-chao.xie@marvell.com>
	<87r4nc18i1.fsf@free.fr>
Date: Mon, 3 Dec 2012 10:40:53 +0800
Message-ID: <CADApbehR9TcrGU-t2ZqT58O0OswVmJPQ1paceO6k1+ADvU026A@mail.gmail.com>
Subject: Re: [PATCH 2/4] rtc: pxa: fix rtc caculation issue
From: Chao Xie <xiechao.mail@gmail.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Chao Xie <chao.xie@marvell.com>, a.zummo@towertech.it,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        haojian.zhuang@gmail.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 4:04 AM, Robert Jarzmik <robert.jarzmik@free.fr> wrote:
> Chao Xie <chao.xie@marvell.com> writes:
>
> Hi Chao Xie,
>
> First of all, could you please send patches from rtc-pxa to me also, as I'm
> maintaining that driver ?
>
> Second point, the original design of the driver relies on the special case of
> writing zeroes to WOM and DOM, as mentionned in PXA27x Developers Guide, chapter
> 21.4.2.3.5 "Writing Alarm Registers with Invalid (Zero) Data", which states :
>> Day-Of-Week (DOW), or Week-Of-Month (WOM), Day of Month (DOM), Month or Year
>> fields—Zero is not valid for these fields. If zero is written into any of
>> these fields, it is ignored while generating the alarm.
>
> I'd like to know if your patch fixes something, or is an enhancement ?
>
> Cheers.
>
> --
> Robert
>
> PS: I've not checked the patch yet, that's just a prelimary comment on the patch
> message.

hi
I am sorry, i just use get_maintainer.pl to get the "to" list.
I have go through the spec. The spec has the desctiption about the
invalid data writing.
I am a little confused about the "wrting 0 to DOW". The descrption is
confused. first it said that "If zero is written into any of these
fields, it is ignored
while generating the alarm", then it gives a example, that if writing
0 to DOW, "For example, if a zero is written into a DOW field, the
alarm is set
every day at the time written in the Hours, Minutes, and Seconds
field”. It seems that the Year/Month/Week will not take effect.
I will do the test on the board again, and send out the update.
