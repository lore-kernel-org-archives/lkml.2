Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab1EPIhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:37:34 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:33395 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab1EPIhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:37:33 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DD0E2EE.7010107@cam.ac.uk>
Date: Mon, 16 May 2011 09:40:14 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Hudson <chudson@kionix.com>
Subject: Re: [PATCH 1/1] input: Add support for Kionix KXTJ9 accelerometer
References: <1305310406-9870-1-git-send-email-chudson@kionix.com>	<1305310406-9870-2-git-send-email-chudson@kionix.com> <20110513192710.5b4791ca@lxorguk.ukuu.org.uk>
In-Reply-To: <20110513192710.5b4791ca@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll leave taking a proper look until you have cleared up the issues Alan pointed out.
But as I was taking a quick look...

Firstly I concur entirely with Alan in that most of the sysfs stuff should be
platform data for an input driver.
...
> 
>> +	memcpy(tj9->pdata, client->dev.platform_data, sizeof(*tj9->pdata));
>> +	if (tj9->pdata->init) {
>> +		err = tj9->pdata->init();
>> +		if (err < 0)
>> +			goto err2;
>> +	}
>> +
>> +	tj9->irq = gpio_to_irq(tj9->pdata->gpio);
> 
> What if it's not on a gpio. Probably better any gpio and irq conversion is
> done by the platform callback/init code
Perfectly good irq element in i2c_board_info structure.  This is exactly what
it is normally used for.
> 
> 
> And the sysfs nodes need documentation.
Would be nice to have some docs on that platform data struct as well.
Most of it is fairly obvious, but data_odr_init etc aren't!
> 
> 
> Overall it looks like a lot of input drivers that get posted here
> 
> - Nobody has considered locking between actions and sysfs (or multiple
>   sysfs actions in parallel)
> - Enable/disable is implemented in blissful ignorance of what happens if
>   a disable occurs during a sysfs or other action
> 
> Most of the rest looks like it just needs a good polish.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

