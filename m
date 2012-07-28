Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab2G1PS5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 11:18:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59064 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2G1PS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 11:18:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120727155208.GB535@kroah.com>
References: <1343361763-10307-1-git-send-email-bryan.wu@canonical.com>
 <1343361763-10307-2-git-send-email-bryan.wu@canonical.com> <20120727155208.GB535@kroah.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Sat, 28 Jul 2012 23:18:35 +0800
X-Google-Sender-Auth: jXZT7KZ_RJnOPTsb3iam4W5il_w
Message-ID: <CAK5ve-LVkKt0RCDqJrHeG1U2ChKv2mm+UvkpdhZuXVwu7XrgaQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] sysfs: introduce a sysfs_create_file_uevent new API
To: Greg KH <gregkh@linuxfoundation.org>
Cc: ccross@android.com, hmh@hmh.eng.br, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 11:52 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Jul 27, 2012 at 12:02:41PM +0800, Bryan Wu wrote:
>> Send a uevent notification whenever a new sysfs file is created to allow
>> userspace processes such as udev to modify permissions on the new files.
>
> This makes no sense, why not just call kobject_uevent after creating the
> file when needed?  Wrapping it up in a single function call doesn't add
> any benefit that I can see, can you?
>

I actually just want to make it benefit for further similar issue in
other subsystem, although I got this point from the email started by
Colin Cross. I agree if it is just specific to LED subsystem, we'd
better add this fixing in LED trigger core code. Maybe I worried about
too much and if you guys all ack Colin's patch, I'm going to apply it.

Thanks,
-Bryan

>>
>> This new API function helps to do this.
>>
>> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
>> ---
>>  fs/sysfs/file.c       | 28 ++++++++++++++++++++++++++++
>>  include/linux/sysfs.h | 13 +++++++++++++
>>  2 files changed, 41 insertions(+)
>>
>> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
>> index 00012e3..5a22d13 100644
>> --- a/fs/sysfs/file.c
>> +++ b/fs/sysfs/file.c
>> @@ -576,6 +576,34 @@ int sysfs_create_file(struct kobject * kobj, const struct attribute * attr)
>>
>>  }
>>
>> +/**
>> + *   sysfs_create_file_uevent - create an attribute file for an object
>> +                                     and send a uevent to userspace.
>
> kerneldoc needs to be on one line for function names, right?
>
> greg k-h



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
