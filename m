Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab1BPGKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 01:10:06 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:48011 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab1BPGKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 01:10:03 -0500
Message-ID: <4D5B6AF2.8060104@wytron.com.tw>
Date: Wed, 16 Feb 2011 14:13:06 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        linux-i2c@vger.kernel.org, Albert Herranz <albert_herranz@yahoo.es>
Subject: Re: [PATCH v5] i2c-gpio: add devicetree support
References: <1297304967-3759-1-git-send-email-thomas@wytron.com.tw> <1297650610-12400-1-git-send-email-thomas@wytron.com.tw> <20110216054956.GD11684@angua.secretlab.ca>
In-Reply-To: <20110216054956.GD11684@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 02/16/2011 01:49 PM, Grant Likely wrote:
> On Mon, Feb 14, 2011 at 10:30:10AM +0800, Thomas Chou wrote:
>> From: Albert Herranz<albert_herranz@yahoo.es>
>>
>> This patch adds devicetree support to i2c-gpio driver. The allocation
>> of local data is integrated to a private structure, and use devm_*
>> helper for easy cleanup.
>>
>> It is base on an earlier patch for gc-linux from
>> Albert Herranz<albert_herranz@yahoo.es>.
>>
>> Signed-off-by: Thomas Chou<thomas@wytron.com.tw>
>> CC: Albert Herranz<albert_herranz@yahoo.es>
>> Acked-by: Haavard Skinnemoen<hskinnemoen@gmail.com>
>
> One minor nitpick below, but I'd be fine with cleaning that up via a
> followup patch.  This one looks correct to me.
>
> Acked-by: Grant Likely<grant.likely@secretlab.ca>
>
> Ben, this one depends on a patch in my devicetree/next tree.  How do
> you want to handle it?
>
> g.
>

Thanks a lot.

>> +#ifdef CONFIG_OF
>> +#include<linux/of_gpio.h>
>
> Instead of putting the include here, please add #ifdef CONFIG_OF
> protection around the contents of linux/of_gpio.h itself.  I fully
> support that change so that includes can remain at the top where they
> belong.

Then, my earlier patch on Jan 31, might be another solution. This way 
of_gpio.h can be included at the top, and those of_gpio users will be 
optimized out when of or of_gpio is not configured.

[PATCH 2/3] of: of_gpiochip_add is needed only for gpiolib

Cheers,
Thomas

