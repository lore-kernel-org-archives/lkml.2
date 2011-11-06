Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1KFDYi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 23:24:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63769 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab1KFDYh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 23:24:37 -0400
MIME-Version: 1.0
In-Reply-To: <20111105182244.GB6772@elf.ucw.cz>
References: <1320392176-3906-1-git-send-email-Barry.Song@csr.com> <20111105182244.GB6772@elf.ucw.cz>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 6 Nov 2011 11:24:15 +0800
Message-ID: <CAGsJ_4xU28APFEcALAzuB2jAACa8FbOR6iSvOaEeGZa=JyjNeA@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH] PM: HIBERNATION: skip the swap size check if
 the snapshot image size is anticipative
To: Pavel Machek <pavel@ucw.cz>
Cc: Barry Song <Barry.Song@csr.com>, Xiangzhen Ye <Xiangzhen.Ye@csr.com>,
        linux-kernel@vger.kernel.org, Barry Song <Baohua.Song@csr.com>,
        linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/6 Pavel Machek <pavel@ucw.cz>:
> Hi!
>
>> From: Barry Song <Baohua.Song@csr.com>
>>
>> Current swsusp requires swap partitions even larger than real saved pages
>> due to the worst compress ratio:
>> but for an embedded system, which has limited storage space, then it might
>> can't give the big size partition to save snapshot.
>> In the another way, some embedded systems can definitely know the most size
>> needed for snapshot since they run some specific application lists.
>> So this patch provides the possibility for bootloader to tell kernel even
>> the system has a little snapshot partition, but it is still enough.
>> For example, if the system need to save 120MB memory, origin swsusp will require
>> a 130MB partition to save snapshot. but if users know 30MB is enough for them(
>> compressed image will be less than 30MB), they just make a 30MB
>> partition.
>
> Would it be better to have /sys/power/... entry which would allow
> configuring expected compression ratio at runtime?

i think it is better to have a sys node than add another kernel param.
but the point is i only care about the final image size but not
compression ratio. i don't care how well lzo will do for me since i
only have limited disk space and know how many pages want to be saved.
there has been a image_size node, will we have a expected_image_size node?
>                                                                Pavel
>
> --
Thanks
barry
