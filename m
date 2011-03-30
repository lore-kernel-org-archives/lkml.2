Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab1C3JMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:12:51 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65164 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab1C3JMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:12:50 -0400
Message-ID: <9E9CA0E03AAF4C9AA18DDD7CDE5168A8@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Arnd Bergmann" <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        <nsekhar@ti.com>, "open list" <linux-kernel@vger.kernel.org>,
        <m-watkins@ti.com>, "Marc Kleine-Budde" <mkl@pengutronix.de>
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com> <1299592667-21367-2-git-send-email-subhasish@mistralsolutions.com> <201103111628.57549.arnd@arndb.de>
In-Reply-To: <201103111628.57549.arnd@arndb.de>
Subject: Re: [PATCH v3 1/7] mfd: add pruss mfd driver.
Date: Wed, 30 Mar 2011 14:45:16 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

I am using a .setup to initialize pin mux etc. To use the mfd_cells directly 
should I
use .enable and .disable of the mfd_cells instead of the .setup.

>> +static int pruss_mfd_add_devices(struct platform_device *pdev)
>> +{
>> + struct da8xx_pruss_devices *dev_data = pdev->dev.platform_data;
>> + struct device *dev = &pdev->dev;
>> + struct mfd_cell cell;
>> + u32 err, count;
>> +
>> + for (count = 0; dev_data[count].dev_name != NULL; count++) {
>> + memset(&cell, 0, sizeof(struct mfd_cell));
>> + cell.id = count;
>> + cell.name = dev_data[count].dev_name;
>> + cell.platform_data = dev_data[count].pdata;
>> + cell.data_size = dev_data[count].pdata_size;
>> + cell.resources = dev_data[count].resources;
>> + cell.num_resources = dev_data[count].num_resources;
>> +
>> + err = mfd_add_devices(dev, 0, &cell, 1, NULL, 0);
>> + if (err) {
>> + dev_err(dev, "cannot add mfd cells\n");
>> + return err;
>> + }
>> + dev_info(dev, "mfd: added %s device\n",
>> + dev_data[count].dev_name);
>> + }
>> +
>> + return err;
>> +}
>
> This would get much simpler if you just replaced the da8xx_pruss_devices
> array with an mfd_cell array. 

