Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab2DXReb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:34:31 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:57193 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863Ab2DXRea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:34:30 -0400
Message-ID: <4F96E41C.6030309@ahsoftware.de>
Date: Tue, 24 Apr 2012 19:34:20 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120303 Thunderbird/10.0.1
MIME-Version: 1.0
To: shuahkhan@gmail.com
CC: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] leds: heartbeat: stop on shutdown
References: <1335275034-22135-1-git-send-email-holler@ahsoftware.de>  <1335280022-16308-1-git-send-email-holler@ahsoftware.de>  <1335281074.2347.4.camel@lorien2> <4F96D58A.3070008@ahsoftware.de>  <1335286810.2347.18.camel@lorien2> <4F96E26C.3060302@ahsoftware.de> <1335288711.2347.20.camel@lorien2>
In-Reply-To: <1335288711.2347.20.camel@lorien2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.04.2012 19:31, schrieb Shuah Khan:
> On Tue, 2012-04-24 at 19:27 +0200, Alexander Holler wrote:
>> Am 24.04.2012 19:00, schrieb Shuah Khan:
>>> On Tue, 2012-04-24 at 18:32 +0200, Alexander Holler wrote:
>>>> Am 24.04.2012 17:24, schrieb Shuah Khan:
>>>>> On Tue, 2012-04-24 at 17:07 +0200, Alexander Holler wrote:
>>>>>> A halted kernel should not show a heartbeat.
>>>>>>
>>>>>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
>>>>>> ---
>>>>>>  drivers/leds/ledtrig-heartbeat.c |   18 +++++++++++++++++-
>>>>>>  1 files changed, 17 insertions(+), 1 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/leds/ledtrig-heartbeat.c b/drivers/leds/ledtrig-heartbeat.c
>>>>>> index 759c0bb..1c05bd9 100644
>>>>>> --- a/drivers/leds/ledtrig-heartbeat.c
>>>>>> +++ b/drivers/leds/ledtrig-heartbeat.c
>>>>>> @@ -18,6 +18,7 @@
>>>>>>  #include <linux/timer.h>
>>>>>>  #include <linux/sched.h>
>>>>>>  #include <linux/leds.h>
>>>>>> +#include <linux/reboot.h>
>>>>>>  #include "leds.h"
>>>>>>  
>>>>>>  struct heartbeat_trig_data {
>>>>>> @@ -101,13 +102,28 @@ static struct led_trigger heartbeat_led_trigger = {
>>>>>>  	.deactivate = heartbeat_trig_deactivate,
>>>>>>  };
>>>>>>  
>>>>>> +static int heartbeat_reboot_notifier(struct notifier_block *nb,
>>>>>> +				     unsigned long code, void *unused)
>>>>>> +{
>>>>>> +	led_trigger_unregister(&heartbeat_led_trigger);
>>>>>> +	return NOTIFY_DONE;
>>>>>> +}
>>> I am sorry I didn't catch this the last time. Do you need to call
>>> unregister here? Looks like trigger is going away with a registered
>>> reboot notifier. Might be fine, since reboot is going to happen.
>>
>> That unregister is the whole reason of the patch because it disables all
>> running heartbeats on reboot/shutdown. ;)
> 
> Sorry I should have been clear about which unregister. I meant
> unregister_reboot_notifier()

That is needed in case the module will be unloaded.

Regards,

Alexander
