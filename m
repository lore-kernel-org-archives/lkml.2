Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965343Ab1GOIlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 04:41:36 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:46936 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965119Ab1GOIle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 04:41:34 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E1FFD3E.7090103@cam.ac.uk>
Date: Fri, 15 Jul 2011 09:41:34 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.input,gmane.linux.kernel
To: Eric Andersson <eric.andersson@unixphere.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengguang.guo@bosch-sensortec.com, stefan.nilsson@unixphere.com,
        Albert Zhang <xu.zhang@bosch-sensortec.com>
Subject: Re: [PATCH v3 1/1] input: add driver for Bosch Sensortec's BMA150
 accelerometer
References: <1310680572-27410-2-git-send-email-eric.andersson@unixphere.com> <20110714234030.30d6b455@lxorguk.ukuu.org.uk> <20110715082316.5A4792C03C24@bmail01.one.com>
In-Reply-To: <20110715082316.5A4792C03C24@bmail01.one.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/11 09:23, Eric Andersson wrote:
>>> +		values represent the range given as +/- G.
>>> +		Possible values are: 2, 4, 8.
>>> +
>>> +		Reading: returns the current acceleration range.
>>> +
>>> +		Writing: sets a new acceleration range.
>>
>> Same comment as last time - these values are not discoverable so it
>> should set the nearest bigger range.
> 
> And same answer as last time - The values can be retreived by doing a:
> cat range. This whole idea comes from a review comment that Jonathan Cameron
> gave on your bma023 driver [1].
Needs documenting. Right now there is no mention of that here.
> If we could agree on how these values should be represented I will be glad
> to fix it! Dmitry, any preferences?

> 
> [1] http://www.spinics.net/lists/linux-input/msg14271.html
> 
>>> +	for (i = 0, ret = 0; i < ARRAY_SIZE(bw_val); i++)
>>> +		ret += sprintf(buf + ret,
>>> +			(bw_val[i].reg == bw) ? "[%d] " : "%d ",
>>> +			bw_val[i].value);
>>
>> sysfs nodes should really be single values
> 
> Once again it's a previous comment from Jonathan [1]. Please specify how
> you want this and I'll fix it.
Yes in general to the single value, but this is a pretty common syntax for
choosing one of a set.  Got to indicate it somehow and it's either this or
a list of available ones in a separate attribute.  There was an LWN article
on this a while back that lays out the options very clearly http://lwn.net/Articles/378884/
> 
>>> +static const struct i2c_device_id bma150_id[] = {
>>> +	{ "bma150", 0 },
>>> +	{ "smb380", 0 },
>>
>> bma023 ?
> 
> As mentioned earlier bma023 is not an official product name from Bosch Sensortec. Hence,
> there will be no datasheet available or references from Bosch Sensortec. IMHO it would be
> confusing to add it.
Just ignore the marketing and add it anyway :)
>  
>> It also doesn't expose the thresholds or support interrupts which the
>> one I posted did.
> 
> We were told by Bosch S that the interrupt is triggered every 333 us (data ready) which would
> pretty much flood the irq handler.
Somewhat quick, but maybe still worth having...  Just use a one shot threaded interrupt and it
will at least run safely even if it isn't keeping up with all of them.  Alan, do you have a device
that has frequency control on chip? (very unusual not to see this on an accelerometer).

> However, if this is stopping the patch we can add it. Would it be acceptable to have a driver
> that supports both a polling and irq driven setup, e.g. by checking if the .irq is non zero?
Yes: common situation. See the recent kionix driver for an example.
You definitely want the theshold stuff from Alan's driver though.
> 
>> So while its better it still seems incomplete - its certainly nowhere
>> near where it can replace the one I posted months ago and doesn't seem
>> to
>> be making any headway.
>>
>> Dmitry shall I repost the intel one - at this point I think it would
>> be a
>> better starting point as it supports more features, interrupts and the
>> like although it's not perfect either.
> 
> My hope is that we can sort out the differences before I post v4. Dmitry, if you have time
> could you please give an objective review of the patch?
> 
> Best regards,
>  Eric
> 
> http://www.unixphere.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

