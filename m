Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab2JKFlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 01:41:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55672 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab2JKFlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 01:41:00 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50765BD2.10705@jp.fujitsu.com>
Date: Thu, 11 Oct 2012 14:40:34 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lenb@kernel.org>, <wency@cn.fujitsu.com>,
        <vasilis.liaskovitis@profitbricks.com>
Subject: Re: acpi : acpi_bus_trim() stops removing devices when failing to
 remove the device
References: <5073E4CC.3090600@jp.fujitsu.com>  <1349800566.23493.9.camel@misato.fc.hp.com>  <5074CA61.3010802@jp.fujitsu.com> <1349874065.23493.23.camel@misato.fc.hp.com>
In-Reply-To: <1349874065.23493.23.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

2012/10/10 22:01, Toshi Kani wrote:
> On Wed, 2012-10-10 at 10:07 +0900, Yasuaki Ishimatsu wrote:
>   :
>>>>    	if (acpi_drv) {
>>>>    		if (acpi_drv->ops.notify)
>>>>    			acpi_device_remove_notify_handler(acpi_dev);
>
> THIS CALL
>
>>>> -		if (acpi_drv->ops.remove)
>>>> -			acpi_drv->ops.remove(acpi_dev, acpi_dev->removal_type);
>>>> +		if (acpi_drv->ops.remove) {
>>>> +			ret = acpi_drv->ops.remove(acpi_dev,
>>>> +						   acpi_dev->removal_type);
>>>> +			if (ret)
>>>
>>> Hi Yasuaki,
>>>
>>> Shouldn't the notify handler be reinstalled here if it was removed by
>>> the acpi_device_remove_notify_handler() above?
>>
>> I do not reinstall the notify handler.
>> The function has not been removed on linux-3.6. And the patch is created
>> on linux-3.6. So the function remains in the patch.
>
> Umm... I am not sure what you meant.  Let me clarify my comment.  When
> acpi_drv->ops.remove() failed, I thought we would need to roll-back the
> procedure done by the acpi_device_remove_notify_handler() call, which I
> indicated as "THIS CALL" above.  So, in this error path, don't we need
> something like below?
>
> if (acpi_drv->ops.notify)
> 	acpi_device_install_notify_handler(acpi_dev)

I understood what you said.  I'll update it.

Thanks,
Yasuaki Ishimatsu

>
> Thanks,
> -Toshi
>
>
>
>


