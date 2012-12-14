Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab2LNORM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 09:17:12 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:46336 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab2LNORL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 09:17:11 -0500
Message-ID: <50CB347B.80305@ahsoftware.de>
Date: Fri, 14 Dec 2012 15:15:23 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4 v4] rtc: add rtc-driver for HID sensors of type time
References: <50C8591A.3030301@ahsoftware.de> <1355310680-2466-1-git-send-email-holler@ahsoftware.de> <50CAF473.6040901@metafoo.de> <50CB24D4.3030606@ahsoftware.de>
In-Reply-To: <50CB24D4.3030606@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.12.2012 14:08, schrieb Alexander Holler:
> Am 14.12.2012 10:42, schrieb Lars-Peter Clausen:

>> And another thing I've overlooked before:
>> wait_for_completion_interruptible_timeout can either return a positive
>> number when the completion was completed, 0 in case of an timeout, or a
>> negative error code in case it was interrupted. You need to handle all
>> three. E.g. something like this.
>>
>> ret = wait_for_completion_interruptible_timeout(...)
>> if (ret == 0)
>>     return -EIO;
>> if (ret < 0)
>>     return ret
>>
>
> Hmpf, the only working approach to use some in kernel functions really
> is to the read source yourself and don't trust anything else. :/

Anyway, my approach doesn't work as it introduces a race condition:


/* get a report with all values through requesting one value */
sensor_hub_input_attr_get_raw_value(...)

/* race if this task goes to slepp and the values were
received before it could call the below wait...

/* wait for all values (event) */
if (!wait_for_completion_interruptible_timeout(...))


I'll have to look for a mechanism how to avoid that. So v5 might need 
some time.


Regards,

Alexander

