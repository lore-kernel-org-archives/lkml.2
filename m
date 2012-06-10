Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab2FJApM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 20:45:12 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43985 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab2FJApK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 20:45:10 -0400
MIME-Version: 1.0
In-Reply-To: <4FD39998.4020903@mvista.com>
References: <1339263678-4075-1-git-send-email-linkinjeon@gmail.com>
	<4FD39998.4020903@mvista.com>
Date: Sun, 10 Jun 2012 09:45:08 +0900
Message-ID: <CAKYAXd9Evpo6jn+_+bnyNeaX9vmPicVp5Xm-12tp_U4=wb6Pgw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] usb: storage: update usb devices for write cache
 quirk in quirk list.
From: Namjae Jeon <linkinjeon@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: James.Bottomley@hansenpartnership.com, gregkh@linuxfoundation.org,
        mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu,
        bvanassche@acm.org, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/10, Sergei Shtylyov <sshtylyov@mvista.com>:
> Hello.
>
> On 06/09/2012 09:41 PM, Namjae Jeon wrote:
>
>> Update information of Seagate Portable HDD and WD My Passport HDD in
>> quirk list.
>
>> Signed-off-by: Namjae Jeon<namjae.jeon@samsung.com>
>> Signed-off-by: Pankaj Kumar<pankaj.km@samsung.com>
>> Signed-off-by: Amit Sahrawat<a.sahrawat@samsung.com>
>> ---
>>   drivers/usb/storage/unusual_devs.h |   24 ++++++++++++++++++++++++
>>   1 file changed, 24 insertions(+)
>
>> diff --git a/drivers/usb/storage/unusual_devs.h
>> b/drivers/usb/storage/unusual_devs.h
>> index 1719886..64f0369 100644
>> --- a/drivers/usb/storage/unusual_devs.h
>> +++ b/drivers/usb/storage/unusual_devs.h
>> @@ -1267,6 +1267,18 @@ UNUSUAL_DEV( 0x0af0, 0xd357, 0x0000, 0x0000,
>>   		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>>   		0 ),
>>
>> +/* Reported by Namjae Jeon<namjae.jeon@samsung.com>
>> + * Even though write cache is enabled by default,
>> + * SCSI driver assume that cache is not enabled
>> + * which in turn might lead loss of data
>                                ^ to the
>
>> + * since data still will be in cache.
>> + * So this entry is needed for assuming that cache is enabled.
>> + */
>> +UNUSUAL_DEV(0x0bc2, 0x2300, 0x0000, 0x9999,
>> +		"Seagate",
>> +		"Portable HDD",
>> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),
>> +
>>   /* Reported by Ben Efros<ben@pc-doctor.com>  */
>>   UNUSUAL_DEV( 0x0bc2, 0x3010, 0x0000, 0x0000,
>>   		"Seagate",
>> @@ -1468,6 +1480,18 @@ UNUSUAL_DEV(  0x1058, 0x0704, 0x0000, 0x9999,
>>   		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>>   		US_FL_SANE_SENSE),
>>
>> +/* Reported by Namjae Jeon<namjae.jeon@samsung.com>
>> + * Even though write cache is enabled by default,
>> + * SCSI driver assume that cache is not enabled
>> + * which in turn might lead loss of data
>                                ^ to the
to the ? Sorry, I don't understand what you want to change.
like this ? "Even though write cache is enabled by default, SCSI
driver assume that cache is not enabled and it in turn might lead the
loss of data. "

>
> WBR, Sergei
>
