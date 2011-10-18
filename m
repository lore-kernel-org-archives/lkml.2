Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab1JRM7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 08:59:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34850 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab1JRM7N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 08:59:13 -0400
MIME-Version: 1.0
In-Reply-To: <4E9D76D9.7070302@cam.ac.uk>
References: <1318939596-27330-1-git-send-email-ricardo.ribalda@gmail.com>
 <1318939596-27330-2-git-send-email-ricardo.ribalda@gmail.com> <4E9D76D9.7070302@cam.ac.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 18 Oct 2011 14:58:33 +0200
Message-ID: <CAPybu_3mC5HnHZeic+D7G=K3oz_yyMAOkepBZmGmj6gPEZoY4A@mail.gmail.com>
Subject: Re: [PATCHv2 1/7] input/cma3000_d0x: Support devices without pdata
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, hemanthv@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jonathan

I think I am going to do it like ads1015.c. I will check for the
pdata, then for the dt info (if it is there) and finally go for the
default, if all fails. What do you think? Shall I fix it in cma3000
and cmr3000?

 Thanks again

On Tue, Oct 18, 2011 at 14:53, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> On 10/18/11 13:06, Ricardo Ribalda Delgado wrote:
>> Architectures based on device-tree does not have platform data
>> associated to the spi/i2c devices.
>> This patch allows those architectures to use the cma3000 driver with
>> a default configuration.
> Fine except for this description. Looks to be a perfectly reasonable
> way of specifying these in DT.  So fix that and I'm happy.
> Whoever wants to pass this in from DT can do a patch for it!
>>
>> ---
>>
>> v2: Fixes suggested by Jonathan Cameron
>>     -Spelling
>>     -Simplify pdata!=NULL check
>>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
>> ---
>>  drivers/input/misc/cma3000_d0x.c |   20 +++++++++++++++-----
>>  1 files changed, 15 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c
>> index 1633b63..f2e87e3 100644
>> --- a/drivers/input/misc/cma3000_d0x.c
>> +++ b/drivers/input/misc/cma3000_d0x.c
>> @@ -62,6 +62,18 @@
>>  #define BIT_TO_2G  18
>>  #define BIT_TO_8G  71
>>
>> +static struct cma3000_platform_data cma3000_default_pdata = {
>> +     .mdthr = 0x8,
>> +     .mdfftmr = 0x33,
>> +     .ffthr = 0x8,
>> +     .mode = CMAMODE_MEAS400,
>> +     .g_range = CMARANGE_2G,
>> +     .fuzz_x = BIT_TO_2G,
>> +     .fuzz_y = BIT_TO_2G,
>> +     .fuzz_z = BIT_TO_2G,
>> +     .irqflags = 0,
>> +};
>> +
>>  struct cma3000_accl_data {
>>       const struct cma3000_bus_ops *bus_ops;
>>       const struct cma3000_platform_data *pdata;
>> @@ -289,13 +301,11 @@ struct cma3000_accl_data *cma3000_init(struct device *dev, int irq,
>>       int rev;
>>       int error;
>>
>> -     if (!pdata) {
>> -             dev_err(dev, "platform data not found\n");
>> -             error = -EINVAL;
>> -             goto err_out;
>> +     if (pdata == NULL) {
>> +             dev_info(dev, "platform data not found, using default\n");
>> +             pdata = &cma3000_default_pdata;
>>       }
>>
>> -
>>       /* if no IRQ return error */
>>       if (irq == 0) {
>>               error = -EINVAL;
>
>



-- 
Ricardo Ribalda
