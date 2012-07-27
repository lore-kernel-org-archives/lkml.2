Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab2G0MGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 08:06:54 -0400
Received: from mail.tpi.com ([70.99.223.143]:4229 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab2G0MGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 08:06:46 -0400
Message-ID: <50128446.1010609@canonical.com>
Date: Fri, 27 Jul 2012 06:06:30 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] cx25840: Declare MODULE_FIRMWARE usage
References: <1343321059-124171-1-git-send-email-tim.gardner@canonical.com> <1343339959.2575.3.camel@palomino.walls.org>
In-Reply-To: <1343339959.2575.3.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 03:59 PM, Andy Walls wrote:
> On Thu, 2012-07-26 at 10:44 -0600, Tim Gardner wrote:
>> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
>> Cc: linux-media@vger.kernel.org
>> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
>> ---
>>   drivers/media/video/cx25840/cx25840-firmware.c |   15 ++++++++++++---
>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/video/cx25840/cx25840-firmware.c b/drivers/media/video/cx25840/cx25840-firmware.c
>> index 8150200..b3169f9 100644
>> --- a/drivers/media/video/cx25840/cx25840-firmware.c
>> +++ b/drivers/media/video/cx25840/cx25840-firmware.c
>> @@ -61,6 +61,10 @@ static void end_fw_load(struct i2c_client *client)
>>   	cx25840_write(client, 0x803, 0x03);
>>   }
>>
>> +#define CX2388x_FIRMWARE "v4l-cx23885-avcore-01.fw"
>> +#define CX231xx_FIRMWARE "v4l-cx231xx-avcore-01.fw"
>> +#define CX25840_FIRMWARE "v4l-cx25840.fw"
>> +
>>   static const char *get_fw_name(struct i2c_client *client)
>>   {
>>   	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
>> @@ -68,10 +72,10 @@ static const char *get_fw_name(struct i2c_client *client)
>>   	if (firmware[0])
>>   		return firmware;
>>   	if (is_cx2388x(state))
>> -		return "v4l-cx23885-avcore-01.fw";
>> +		return CX2388x_FIRMWARE;
>>   	if (is_cx231xx(state))
>> -		return "v4l-cx231xx-avcore-01.fw";
>> -	return "v4l-cx25840.fw";
>> +		return CX231xx_FIRMWARE;
>> +	return CX25840_FIRMWARE;
>>   }
>>
>>   static int check_fw_load(struct i2c_client *client, int size)
>> @@ -164,3 +168,8 @@ int cx25840_loadfw(struct i2c_client *client)
>>
>>   	return check_fw_load(client, size);
>>   }
>> +
>> +MODULE_FIRMWARE(CX2388x_FIRMWARE);
>> +MODULE_FIRMWARE(CX231xx_FIRMWARE);
>> +MODULE_FIRMWARE(CX25840_FIRMWARE);
>> +
>
> How will the firmware attribute in the .module_info section be used?
>
> For any one model of TV capture device, the cx25840 only needs one of
> the above firmware files.  The others need not exist.
>
> I would not want anything in user or kernel space to refuse to load the
> module just because all 3 firmware files are not present.
>
> Regards,
> Andy
>

The MODULE_FIRMWARE macro is purely informational. Declaring the 
firmware files that the driver _might_ use helps me pare down the 
external firmware package to just those files that I know it must have. 
This patch will have no runtime impact.

Note that there are plenty of uses of the MODULE_FIRMWARE macro within 
the kernel.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
