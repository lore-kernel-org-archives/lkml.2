Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964772Ab2HGC5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 22:57:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63471 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab2HGC5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 22:57:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAMbhsRS82FM90sD52qTTdOFJCoR4GyP+v6bwv+4NKhjn-sqh-Q@mail.gmail.com>
References: <1343176370-5856-1-git-send-email-ccross@android.com>
 <CAK5ve-LY1iw7CanrMSZ0PtK=Fk9Au9tXnmaOuZ5P7vnP+5VAgA@mail.gmail.com>
 <CAMbhsRS-TiBE92nL0Cwc-ssZAMaHE2ET0UE8h7RU3VG6F6+Xtw@mail.gmail.com>
 <CAK5ve-+11J4HRepAmK-Y0Pq55XhAwa8Ehpw8=KvRdu4Cy90FDQ@mail.gmail.com>
 <20120726035958.GB7235@kroah.com> <CAK5ve-LbNeJngQPE=893-ChJXEWJHg9km1Ev6GZYx4=Zrrxg9g@mail.gmail.com>
 <20120726165112.GA23857@kroah.com> <CAK5ve-KFsFwnvd3TwAvTuBfEdTV8PeNBkVpdQT9NYXH2sN+mBA@mail.gmail.com>
 <CAMbhsRS82FM90sD52qTTdOFJCoR4GyP+v6bwv+4NKhjn-sqh-Q@mail.gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 7 Aug 2012 10:57:29 +0800
X-Google-Sender-Auth: 5yPJMz-oqjDSPAX_h217DZpd78I
Message-ID: <CAK5ve-KvdokobzjmuXSsEZxrJcr7i4xHOXJGvMqCSOZ69G_5zw@mail.gmail.com>
Subject: Re: [PATCH] leds: triggers: send uevent when changing triggers
To: Colin Cross <ccross@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 1, 2012 at 2:28 AM, Colin Cross <ccross@android.com> wrote:
> On Thu, Jul 26, 2012 at 9:04 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
>> On Fri, Jul 27, 2012 at 12:51 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>> On Thu, Jul 26, 2012 at 01:03:11PM +0800, Bryan Wu wrote:
>>>> Just one quick patch for my idea: emitting a uevent in sysfs_create_file().
>>>>
>>>> --
>>>> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
>>>> index 00012e3..04da869 100644
>>>> --- a/fs/sysfs/file.c
>>>> +++ b/fs/sysfs/file.c
>>>> @@ -570,10 +570,14 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd,
>>>> const struct attribute *attr,
>>>>
>>>>  int sysfs_create_file(struct kobject * kobj, const struct attribute * attr)
>>>>  {
>>>> +       int err = 0;
>>>> +
>>>>         BUG_ON(!kobj || !kobj->sd || !attr);
>>>>
>>>> -       return sysfs_add_file(kobj->sd, attr, SYSFS_KOBJ_ATTR);
>>>> +       err = sysfs_add_file(kobj->sd, attr, SYSFS_KOBJ_ATTR);
>>>> +       kobject_uevent(kobj, KOBJ_CHANGE);
>>>
>>> That's a veritable flood of change events when a new kobject is created,
>>> right?  It also created uevents for a device that has not told userspace
>>> that it is even present, which could cause massive confusion, don't you
>>> think?
>>>
>>
>> Indeed, this is unacceptable. I reworked a new patchset and just sent
>> our for you review.
>>
>> Thanks,
>> -Bryan
>
> Given the rejection of the other solutions to this problem, and chance
> of getting this acked?

Greg, Richard and Henrique, can I take you guys' Ack here?

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
