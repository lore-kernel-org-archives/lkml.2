Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab0ERDMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 23:12:01 -0400
Received: from smtp-out.google.com ([74.125.121.35]:42221 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab0ERDL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 23:11:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=lUGcGZllzaVFEyfEQQCSJKDzgrnWQgr32AUsDUnMPhCiosIbR+VJnHtr40q/8Pw3Y
	MOzkd7FAgZ+jA4E8v4p/Q==
MIME-Version: 1.0
In-Reply-To: <4BF1FD33.4040305@ct.jp.nec.com>
References: <20100514035347.GA20636@redhat.com>
	 <1273887701-2152-1-git-send-email-wad@chromium.org>
	 <4BF1FD33.4040305@ct.jp.nec.com>
Date: Mon, 17 May 2010 22:11:55 -0500
X-Google-Sender-Auth: 0vVskpp4iWtVYgeTTI4lpU3Yew0
Message-ID: <AANLkTimHUPh0UHEU-5YckhwppX8AhFBYBxc4BZiIpmfZ@mail.gmail.com>
Subject: Re: [dm-devel] [RFC PATCH v2 1/2] dm: allow a dm-fs-style device to 
	be shared via dm-ioctl
From: Will Drewry <wad@chromium.org>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, snitzer@redhat.com, agk@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 9:36 PM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> Hi Will,
>
> n 05/15/2010 10:41 AM +0900, Will Drewry wrote:
>> In addition, it ensures that public functions are available that
>> allow mapped devices and tables to be created and associated
>> with the shared code paths with dm-ioctl:
>> - suspend flags are available
> snip
>> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
>> index bad1724..782d867 100644
>> --- a/drivers/md/dm.h
>> +++ b/drivers/md/dm.h
>> @@ -17,12 +17,6 @@
>>  #include <linux/hdreg.h>
>>
>>  /*
>> - * Suspend feature flags
>> - */
>> -#define DM_SUSPEND_LOCKFS_FLAG               (1 << 0)
>> -#define DM_SUSPEND_NOFLUSH_FLAG              (1 << 1)
>> -
>> -/*
>>   * Type of table and mapped_device's mempool
>>   */
>>  #define DM_TYPE_NONE         0
>> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
>> index 1381cd9..6c1c230 100644
>> --- a/include/linux/device-mapper.h
>> +++ b/include/linux/device-mapper.h
>> @@ -215,6 +215,18 @@ void dm_set_mdptr(struct mapped_device *md, void *ptr);
>>  void *dm_get_mdptr(struct mapped_device *md);
>>
>>  /*
>> + * Export the device via the ioctl interface (uses mdptr).
>> + */
>> +int dm_ioctl_export(struct mapped_device *md, const char *name,
>> +                 const char *uuid);
>> +
>> +/*
>> + * Suspend feature flags
>> + */
>> +#define DM_SUSPEND_LOCKFS_FLAG               (1 << 0)
>> +#define DM_SUSPEND_NOFLUSH_FLAG              (1 << 1)
>> +
>> +/*
>>   * A device can still be used while suspended, but I/O is deferred.
>>   */
>>  int dm_suspend(struct mapped_device *md, unsigned suspend_flags);
>
> Why do you need suspend feature flags?
> I think no feature is needed (specifying '0' is enough) to make/suspend
> a dm device at boot time (although I have looked at only this flag part).
> Am I missing something?

Not at all! I hadn't thoroughly reviewed the code path for flush/noflush
and was hoping to avoid additional code paths.  However, looking at
effect, I don't see any tangible benefit to doing so with a brand new
device.

I'll switch it over to 0, and I can take exposing the flags out of this
patch.

Any additional comments are appreciated -  thanks!
will
