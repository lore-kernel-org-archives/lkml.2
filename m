Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab0DNOs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:48:59 -0400
Received: from ppsw-c.csi.cam.ac.uk ([131.111.8.136]:43030 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755201Ab0DNOs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:48:57 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BC5D681.20707@jic23.retrosnub.co.uk>
Date: Wed, 14 Apr 2010 15:51:45 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Alan Cox <alan@linux.intel.com>,
       linux-i2c@vger.kernel.org, khali@linux-fr.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] hmc6352: Add driver for the HMC6352 compass
References: <20100414124913.23181.75903.stgit@localhost.localdomain>	<20100414125136.23181.16788.stgit@localhost.localdomain>	<4BC5C7A8.1040807@cam.ac.uk> <20100414153234.22765666@lxorguk.ukuu.org.uk>
In-Reply-To: <20100414153234.22765666@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/10 15:32, Alan Cox wrote:
>> This is in no way a hwmon chip.  Surely misc is a better location for now
>> (pending the usual discussion about all singing all dancing sensors frameworks).
> 
> Yep it's moving at the moment
> 
> 
>>> +#include <linux/module.h>
>>> +#include <linux/init.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/i2c.h>
>>> +#include <linux/hwmon.h>
>>
>> Why these extra hwmon includes?  At least at first glance I can't see
>> any uses of them.  The only call to hwmon is to stick this in the
>> hwmon class.
> 
> I inherited it for cleanup so these are good points (I've been staring at
> piles of these for so long extra input is very useful - this is the tip
> of the iceberg !)
Cool, post away.  Feel free to cc me in on anything in the category of general
sensors (accelerometers, magnetometers etc). If nothing else, I'm interested
to see them to get ideas for drivers in IIO etc.
> 
>>> +#include <linux/hwmon-sysfs.h>
>>> +#include <linux/hwmon-vid.h>
>>> +#include <linux/err.h>
>>> +#include <linux/delay.h>
>> or any mutex usage?
>>> +#include <linux/mutex.h>
>>> +#include <linux/sysfs.h>
>>> +
>>
>> I guess this makes the driver look like many others, but why bother with
>> the wrapping structure?  This is only used to keep track of the hwmon
>> device to be able to remove it later.
> 
> Should go - agreed will remove
> 
>> These address changes looking a little unusual to me.  They may well be needed, but
>> if so can we have an explanatory comment?
> 
> Will investigate.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

