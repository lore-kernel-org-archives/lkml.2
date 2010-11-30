Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab0K3JoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 04:44:14 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:58572 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752623Ab0K3JoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 04:44:13 -0500
Message-ID: <4CF4C767.70107@stericsson.com>
Date: Tue, 30 Nov 2010 10:44:07 +0100
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>
Subject: Re: [PATCH] MFD: ab8500 chip id exported to sysfs
References: <1290773125-9031-1-git-send-email-mattias.wallin@stericsson.com> <20101126154303.GC27663@sortiz-mobl>
In-Reply-To: <20101126154303.GC27663@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/26/2010 04:43 PM, Samuel Ortiz wrote:
> Hi Mattias,
> 
> On Fri, Nov 26, 2010 at 01:05:25PM +0100, Mattias Wallin wrote:
>> This patch adds a file into sysfs for reading out chip id.
>> It have been requested for modem silent reboot.
>>
>> Change-Id: I8e2c10e740a90ab210e023df4214b422c01f2efb
> I suppose this is some internal ID ? Please remove it from the Changelog.
Sorry.
> 
> 
>> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
>> Signed-off-by: Ludovic Barre <ludovic.barre@stericsson.com>
>> ---
>>  drivers/mfd/ab8500-core.c |   27 ++++++++++++++++++++++++++-
>>  1 files changed, 26 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
>> index e64569e..c59e832 100644
>> --- a/drivers/mfd/ab8500-core.c
>> +++ b/drivers/mfd/ab8500-core.c
>> @@ -98,7 +98,7 @@ static int ab8500_get_chip_id(struct device *dev)
>>  	if (!dev)
>>  		return -EINVAL;
>>  	ab8500 = dev_get_drvdata(dev->parent);
>> -	return (int)ab8500->chip_id;
>> +	return ab8500 ? (int)ab8500->chip_id : -EINVAL;
> Here again, you're squeezing some potential bug fix into this patch.
Ok, I'll put this in a seperate patch.
> 
> The rest looks just fine.
> 
> Cheers,
> Samuel.
> 
