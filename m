Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab2G0EFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 00:05:05 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59505 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2G0EFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 00:05:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120726165112.GA23857@kroah.com>
References: <1343176370-5856-1-git-send-email-ccross@android.com>
 <CAK5ve-LY1iw7CanrMSZ0PtK=Fk9Au9tXnmaOuZ5P7vnP+5VAgA@mail.gmail.com>
 <CAMbhsRS-TiBE92nL0Cwc-ssZAMaHE2ET0UE8h7RU3VG6F6+Xtw@mail.gmail.com>
 <CAK5ve-+11J4HRepAmK-Y0Pq55XhAwa8Ehpw8=KvRdu4Cy90FDQ@mail.gmail.com>
 <20120726035958.GB7235@kroah.com> <CAK5ve-LbNeJngQPE=893-ChJXEWJHg9km1Ev6GZYx4=Zrrxg9g@mail.gmail.com>
 <20120726165112.GA23857@kroah.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Fri, 27 Jul 2012 12:04:37 +0800
X-Google-Sender-Auth: bPXYi_q7cIY79CdbwDWwMYE9UhE
Message-ID: <CAK5ve-KFsFwnvd3TwAvTuBfEdTV8PeNBkVpdQT9NYXH2sN+mBA@mail.gmail.com>
Subject: Re: [PATCH] leds: triggers: send uevent when changing triggers
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 12:51 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Jul 26, 2012 at 01:03:11PM +0800, Bryan Wu wrote:
>> Just one quick patch for my idea: emitting a uevent in sysfs_create_file().
>>
>> --
>> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
>> index 00012e3..04da869 100644
>> --- a/fs/sysfs/file.c
>> +++ b/fs/sysfs/file.c
>> @@ -570,10 +570,14 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd,
>> const struct attribute *attr,
>>
>>  int sysfs_create_file(struct kobject * kobj, const struct attribute * attr)
>>  {
>> +       int err = 0;
>> +
>>         BUG_ON(!kobj || !kobj->sd || !attr);
>>
>> -       return sysfs_add_file(kobj->sd, attr, SYSFS_KOBJ_ATTR);
>> +       err = sysfs_add_file(kobj->sd, attr, SYSFS_KOBJ_ATTR);
>> +       kobject_uevent(kobj, KOBJ_CHANGE);
>
> That's a veritable flood of change events when a new kobject is created,
> right?  It also created uevents for a device that has not told userspace
> that it is even present, which could cause massive confusion, don't you
> think?
>

Indeed, this is unacceptable. I reworked a new patchset and just sent
our for you review.

Thanks,
-Bryan
