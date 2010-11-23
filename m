Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab0KWV2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 16:28:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63943 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0KWV2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 16:28:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nOX82Yu0xHIBvMlYM+bwToeBysboTj5sLUqWgbvZ2XOyhcytKYkuY+ZvITd/SlE67m
         R9xJU4i2wuza52IZ2pDr9aiASBX+OvPpDzAW2OyckogjhGaNg/3fy87EjzbVSFCjKci4
         fgxjLOpSr7YbQil3RJpcg5S4jvbEqQhGOZcqE=
Message-ID: <4CEC3211.7050503@gmail.com>
Date: Tue, 23 Nov 2010 22:28:49 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Belisko Marek <marek.belisko@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] staging: ft1000: Use misc device instead self created
 device.
References: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>	<1290515373-16145-3-git-send-email-marek.belisko@open-nandra.com>	<4CEBC751.6090906@gmail.com> <AANLkTimWb1KxhUph+bCELJ1nshnTScB1sU+hb=9CTceb@mail.gmail.com>
In-Reply-To: <AANLkTimWb1KxhUph+bCELJ1nshnTScB1sU+hb=9CTceb@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2010 03:00 PM, Belisko Marek wrote:
> On Tue, Nov 23, 2010 at 2:53 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> On 11/23/2010 01:29 PM, Marek Belisko wrote:
>>> Use simple misc device for ioctl driver funtionality testing.
>>>
>>> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
>>> ---
>>>  drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |   90 ++++++++++++++++++---
>>>  1 files changed, 77 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
>>> index 1aec926..d1784a3 100644
>>> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
>>> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
>>> @@ -32,6 +32,7 @@
>>>  #include <linux/poll.h>
>>>  #include <linux/netdevice.h>
>>>  #include <linux/delay.h>
>>> +#include <linux/miscdevice.h>
>>>
>>>  #include <linux/fs.h>
>>>  #include <linux/kmod.h>
>>> @@ -78,6 +79,47 @@ static struct file_operations ft1000fops =
>>>       .llseek         = no_llseek,
>>>  };
>>>
>>> +struct ft1000_misc_device {
>>> +     struct miscdevice dev;
>>> +     int inf_id;
>>> +};
>>> +
>>> +#define FREE_ID (0xFF)
>>> +
>>> +/* we support just 3 devices */
>>> +#define MAX_DEVICE 3
>>
>> No, why this should be converted to miscdevice? Leave it as chrdev.
> Is there any problem with using miscdev?

Yes, if you want more than a single device per system.

> Old interface create /dev nodes with
> calling kernel thread and some usermode_helper or whatever.

Yes, that's crap indeed. But doesn't judge for miscdevice.

> Just convert to misc dev
> where this is done automatically.

So the only thing you need to do is to send a uevent to udev appropriately.

regards,
-- 
js
