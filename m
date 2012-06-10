Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab2FJAaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 20:30:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38139 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab2FJAaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 20:30:11 -0400
MIME-Version: 1.0
In-Reply-To: <4FD39904.2010808@mvista.com>
References: <1339263660-4039-1-git-send-email-linkinjeon@gmail.com>
	<4FD39904.2010808@mvista.com>
Date: Sun, 10 Jun 2012 09:30:09 +0900
Message-ID: <CAKYAXd9EUqxUBw1YWr2FnBrg1K=uGWiaEFYtSgu-J3nZ9sLvuQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] usb: storage: add support for write cache quirk on
 usb hdd
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
>> Add support for write cache quirk on usb hdd. scsi driver will be set to
>> wce
>> by detecting write cache quirk in quirk list when plugging usb hdd.
>
>> Signed-off-by: Namjae Jeon<namjae.jeon@samsung.com>
>> Signed-off-by: Pankaj Kumar<pankaj.km@samsung.com>
>> Signed-off-by: Amit Sahrawat<a.sahrawat@samsung.com>
>> ---
>>   drivers/usb/storage/scsiglue.c |    5 +++++
>>   drivers/usb/storage/usb.c      |    5 ++++-
>>   include/linux/usb_usual.h      |    4 +++-
>>   3 files changed, 12 insertions(+), 2 deletions(-)
>
>> diff --git a/drivers/usb/storage/scsiglue.c
>> b/drivers/usb/storage/scsiglue.c
>> index a324a5d..fe42547 100644
>> --- a/drivers/usb/storage/scsiglue.c
>> +++ b/drivers/usb/storage/scsiglue.c
> [...]
>> @@ -529,6 +529,9 @@ static void adjust_quirks(struct us_data *us)
>>   		case 'o':
>>   			f |= US_FL_CAPACITY_OK;
>>   			break;
>> +		case 'p':
>> +			f |= US_FL_WRITE_CACHE;
>> +			break;
>>   		case 'r':
>>   			f |= US_FL_IGNORE_RESIDUE;
>>   			break;
>
>     You probably should unite this chunk with the documentation update
> patch.
Hi Sergei.
I tried to post documentation update patch(4/4) for this chunk.
Do I misunderstand ?

>
>> diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
>> index 17df360..96fc152 100644
>> --- a/include/linux/usb_usual.h
>> +++ b/include/linux/usb_usual.h
>> @@ -64,7 +64,9 @@
>>   	US_FLAG(NO_READ_CAPACITY_16,	0x00080000)		\
>>   		/* cannot handle READ_CAPACITY_16 */		\
>>   	US_FLAG(INITIAL_READ10,	0x00100000)			\
>> -		/* Initial READ(10) (and others) must be retried */
>> +		/* Initial READ(10) (and others) must be retried */	\
>> +	US_FLAG(WRITE_CACHE, 0x00200000)		\
>
>     You've been already told to keep '\' at the same level with the above
> '\'
> and you're continuing to ignore this.
Ah,,, okay, I will change this code.
Thanks for your review.
>
>> +		/* Write Cache status is not available */
>>
>>   #define US_FLAG(name, value)	US_FL_##name = value ,
>>   enum { US_DO_ALL_FLAGS };
>
> WBR, Sergei
>
