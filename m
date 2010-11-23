Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0KWOAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:00:41 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60884 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab0KWOAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:00:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UNw66IsL3sqVFb6Ii3C0g+tqOemjMivXim3+Wwl4nwUKymPXJJXuQx+IeJSH+iQ2LA
         0er56P3XXmur63PjNia6Y9e77lUb/tZjKJ+XJEX4HsBoWeg8oQj4J0OvLZ/YYc2k5h5i
         WUKXyCLkb7Szj62u8otLVYAp4Nq+HRr4LGCQQ=
MIME-Version: 1.0
In-Reply-To: <4CEBC751.6090906@gmail.com>
References: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
	<1290515373-16145-3-git-send-email-marek.belisko@open-nandra.com>
	<4CEBC751.6090906@gmail.com>
Date: Tue, 23 Nov 2010 15:00:38 +0100
Message-ID: <AANLkTimWb1KxhUph+bCELJ1nshnTScB1sU+hb=9CTceb@mail.gmail.com>
Subject: Re: [PATCH 2/6] staging: ft1000: Use misc device instead self created device.
From: Belisko Marek <marek.belisko@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 2:53 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 11/23/2010 01:29 PM, Marek Belisko wrote:
>> Use simple misc device for ioctl driver funtionality testing.
>>
>> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
>> ---
>>  drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |   90 ++++++++++++++++++---
>>  1 files changed, 77 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
>> index 1aec926..d1784a3 100644
>> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
>> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
>> @@ -32,6 +32,7 @@
>>  #include <linux/poll.h>
>>  #include <linux/netdevice.h>
>>  #include <linux/delay.h>
>> +#include <linux/miscdevice.h>
>>
>>  #include <linux/fs.h>
>>  #include <linux/kmod.h>
>> @@ -78,6 +79,47 @@ static struct file_operations ft1000fops =
>>       .llseek         = no_llseek,
>>  };
>>
>> +struct ft1000_misc_device {
>> +     struct miscdevice dev;
>> +     int inf_id;
>> +};
>> +
>> +#define FREE_ID (0xFF)
>> +
>> +/* we support just 3 devices */
>> +#define MAX_DEVICE 3
>
> No, why this should be converted to miscdevice? Leave it as chrdev.
Is there any problem with using miscdev? Old interface create /dev nodes with
calling kernel thread and some usermode_helper or whatever. Just
convert to misc dev
where this is done automatically.
>
> regards,
> --
> js
>

thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
