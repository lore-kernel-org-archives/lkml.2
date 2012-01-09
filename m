Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2AICvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 21:51:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41155 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2AICvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 21:51:14 -0500
MIME-Version: 1.0
In-Reply-To: <201201082231.44510.rjw@sisk.pl>
References: <1322208422-12346-1-git-send-email-Barry.Song@csr.com>
 <20120105184604.GA11065@atrey.karlin.mff.cuni.cz> <CAGsJ_4ypEKZLXf0KU81=dRADcxesxKVyqg0UnEKGaxthNMZQ-g@mail.gmail.com>
 <201201082231.44510.rjw@sisk.pl>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 9 Jan 2012 10:50:52 +0800
Message-ID: <CAGsJ_4y+fQ14yDzD1FxtutD7b17KqK+voaywHAZuS0SXK5Z_xQ@mail.gmail.com>
Subject: Re: [PATCH v2] PM: HIBERNATION: skip the swap size check if the
 snapshot image size is anticipative
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Barry Song <Barry.Song@csr.com>,
        linux-pm@lists.linux-foundation.org, workgroup.linux@csr.com,
        Xiangzhen Ye <Xiangzhen.Ye@csr.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Barry Song <Baohua.Song@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/9 Rafael J. Wysocki <rjw@sisk.pl>:
> On Friday, January 06, 2012, Barry Song wrote:
>> 2012/1/6 Pavel Machek <pavel@ucw.cz>:
>> > Hi!
>> >
>> > Is the check even useful these days? Should we remove it altogether?
>>
>> i think we can let users or distributions decide whether it is useful.
>> On PC, disk space is not an issue, people might run many applications
>> while doing hibernation, so snapshot is much big. an early check will
>> improve user experience because people don't need to wait a long time
>> and find space is not enough.
>> for embedded system, SoC solutions can know whether the space is
>> enough since they know what are running while doing hibernation, so
>> they can skip the check by setting the flag in sysfs.
>> that is why i had this patch sent.
>
> I agree with Pavel that it's better to drop the check altogether.
>
> The sysfs switch you're adding doesn't seem to be very useful, as PC
> users won't touch it and whoever needs it to be 0, will always set it
> that way and won't change it afterwards.

ok. if we don't have the check, in case swap partition is not enough,
writing failure will happen, system still can restore to normal
status:

for example, in the following test, only 27% data is written with a
small partition, "Restarting tasks ... done" will make system restore
to normal status.

[   11.2080 27%
[   11.403274] PM: Wrote uncompressed 34920 kbytes in 0.65 seconds (53.72 MB/s)
[   11.407649] PM: Wrote compressed 3500 kbytes in 0.65 seconds (5.38 MB/s)
[   11.447176] Restarting tasks ... done.
[   11.448801] ...


>
> Thanks,
> Rafael

-barry
