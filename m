Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab0KCOqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 10:46:10 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:53215 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753540Ab0KCOqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 10:46:08 -0400
Message-ID: <4CD17588.1090601@euromail.se>
Date: Wed, 03 Nov 2010 15:45:28 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 1/8] hwmon: applesmc: Relax the severity
 of device init failure
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se> <1288511434-5662-2-git-send-email-rydberg@euromail.se> <20101102160343.GA30515@ericsson.com>
In-Reply-To: <20101102160343.GA30515@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PDeb7-0004BE-7e.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PDeb7-0004BE-7e b1ee4178024e28e8fafe52e6033f7b44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2010 05:03 PM, Guenter Roeck wrote:

> Hi Henrik,
> 
> On Sun, Oct 31, 2010 at 03:50:27AM -0400, Henrik Rydberg wrote:
>> The device init is used to reset the accelerometer. Failure to reset
>> is not severe enough to stop loading the module or to resume from
>> hibernation.  This patch relaxes failure to a warning and drops
>> output in case of success.
>>
>> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
>> ---
>>  drivers/hwmon/applesmc.c |   24 ++----------------------
>>  1 files changed, 2 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
>> index d7a5b75..375e464 100644
>> --- a/drivers/hwmon/applesmc.c
>> +++ b/drivers/hwmon/applesmc.c
>> @@ -458,21 +458,8 @@ static int applesmc_device_init(void)
>>  	mutex_lock(&applesmc_lock);
>>  
> Since the callers of applesmc_device_init() now all don't check the return value,
> it might make sense to declare it as void and not bother returning an error.
> 
> Otherwise looks good.


Sounds good, will change.

Henrik
