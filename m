Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0K3Q7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:59:07 -0500
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:37510 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab0K3Q7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:59:04 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4CF52EF1.3050000@cam.ac.uk>
Date: Tue, 30 Nov 2010 17:05:53 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101123 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Hemanth V <hemanthv@ti.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        saaguirre@ti.com, Shubhrajyoti@ti.com
Subject: Re: PATCH V4 1/2] input: CMA3000 Accelerometer Driver
References: <37129.10.24.255.17.1291028260.squirrel@dbdmail.itg.ti.com> <4CF38E4D.3070309@cam.ac.uk> <20101130075911.GC15731@core.coreip.homeip.net> <5B8D58FB9E1C487FA94F2498E0B9E9AB@wipblrx0099946>
In-Reply-To: <5B8D58FB9E1C487FA94F2498E0B9E9AB@wipblrx0099946>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/10 12:50, Hemanth V wrote:
> ----- Original Message ----- From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
>>
>> Yep, almost there.
>>
>> Hemanth, does the driver still work if you apply the patch below?
> 
> Yes works pretty well, Thanks for your efforts
> 
> Some minor changes as below required.
> 
> <snip>
> 
>> +struct cma3000_accl_data {
>> + const struct cma3000_bus_ops *bus_ops;
>> + const struct cma3000_platform_data *pdata;
>> +
>> + struct device *dev;
>> + struct input_dev *input_dev;
>> +
>> + int bit_to_mg;
>> + int irq;
>> +
>> + int g_range;
>> + u8 mode;
>> +
>> + struct mutex mutex;
> 
> Need a comment to overcome checkpatch warning.
> 
>>
>> - pr_info("CMA3000 Accelerometer : Revision %x\n", ret);
>> + data->dev = dev;
>> + data->input_dev = input_dev;
>> + data->bus_ops = bops;
>> + data->pdata = pdata;
> 
> Need to add data->irq = irq, else exit routine will dump stack
> 
>>
>> - data->input_dev->name = "cma3000-accelerometer";
>> + data->g_range = pdata->g_range;
>> + if (data->g_range != CMARANGE_2G && data->g_range != CMA3000_RANGE8G) {
> 
> Need to change this to "data->g_range != CMARANGE_2G   && data->g_range != CMARANGE_8G "
> 
>> - input_set_abs_params(data->input_dev, ABS_Z, -g_range,
>> - g_range, fuzz_z, 0);
>> - input_set_abs_params(data->input_dev, ABS_MISC, 0,
>> - 1, 0, 0);
> 
> We use this ABS_MISC event to report free fall.
Free fall isn't a conventional user input...  The lis3 driver
and similar (currently hiding in hwmon)
handle this via a separately registered chrdev.  It might not
be the best plan, but it is an existing interface so we need to
involve them in any discussion if you want to change it.


> 
> 
> 
> 

