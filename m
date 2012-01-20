Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab2ATF72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 00:59:28 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:38137 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088Ab2ATF70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 00:59:26 -0500
Message-ID: <4F1902B8.5020000@ti.com>
Date: Fri, 20 Jan 2012 11:29:20 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Kevin Hilman <khilman@ti.com>
CC: linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC 2/2] OMAP : serial : Check for error in get_context_loss_count
References: <1326377019-23688-1-git-send-email-shubhrajyoti@ti.com>	<1326377019-23688-2-git-send-email-shubhrajyoti@ti.com> <87hazrti1c.fsf@ti.com>
In-Reply-To: <87hazrti1c.fsf@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 January 2012 04:29 AM, Kevin Hilman wrote:
> Shubhrajyoti D <shubhrajyoti@ti.com> writes:
>
>> In serial_omap_runtime_resume in case of errors returned by
>> get_context_loss_count print a warning and do a restore.
>>
>> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> These two patches should be combined into a single patch.
>
OK I will combine. I had split as the one was a serial driver and one
for omap
maintainer.

However I agree that they should be combined.
> Also, please Cc Govindraj since he's the maintainer of this driver and
> should Ack.
will do that
> Thanks,
>
> Kevin
>
>> ---
>> applies on Tony's uart branch
>>
>>  drivers/tty/serial/omap-serial.c |   10 ++++++++--
>>  1 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
>> index 29fe6fd..6008612 100644
>> --- a/drivers/tty/serial/omap-serial.c
>> +++ b/drivers/tty/serial/omap-serial.c
>> @@ -1602,10 +1602,16 @@ static int serial_omap_runtime_resume(struct device *dev)
>>  
>>  	if (up) {
>>  		if (pdata->get_context_loss_count) {
>> -			u32 loss_cnt = pdata->get_context_loss_count(dev);
>> +			int loss_cnt = pdata->get_context_loss_count(dev);
>>  
>> -			if (up->context_loss_cnt != loss_cnt)
>> +			if (loss_cnt < 0) {
>> +				dev_err(dev,
>> +					"get_context_loss_count failed : %d\n",
>> +					loss_cnt);
>>  				serial_omap_restore_context(up);
>> +			} else if (up->context_loss_cnt != loss_cnt) {
>> +				serial_omap_restore_context(up);
>> +			}
>>  		}
>>  
>>  		/* Errata i291 */

