Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3ADOHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 09:07:20 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38622 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab3ADOHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 09:07:13 -0500
Message-ID: <50E6E1FD.40604@ti.com>
Date: Fri, 4 Jan 2013 16:06:53 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <keshava_mgowda@ti.com>, <bjorn@mork.no>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 13/22] mfd: omap-usb-host: override number of ports
 from platform data
References: <1357138842-28964-1-git-send-email-rogerq@ti.com> <1357138842-28964-14-git-send-email-rogerq@ti.com> <50E57F10.6030402@mvista.com>
In-Reply-To: <50E57F10.6030402@mvista.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 02:52 PM, Sergei Shtylyov wrote:
> Hello.
> 
> On 02-01-2013 19:00, Roger Quadros wrote:
> 
>> Both OMAP4 and 5 exhibit the same revision ID in the REVISION register
>> but they have different number of ports i.e. 2 and 3 respectively.
>> So we can't rely on REVISION register for number of ports on OMAP5
>> and depend on platform data (or device tree) instead.
> 
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> [...]
> 
>> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
>> index 5edb828..710460d 100644
>> --- a/drivers/mfd/omap-usb-host.c
>> +++ b/drivers/mfd/omap-usb-host.c
>> @@ -497,19 +497,27 @@ static int usbhs_omap_probe(struct
>> platform_device *pdev)
>>        */
>>       pm_runtime_put_sync(dev);
>>
>> -    switch (omap->usbhs_rev) {
>> -    case OMAP_USBHS_REV1:
>> -        omap->nports = 3;
>> -        break;
>> -    case OMAP_USBHS_REV2:
>> -        omap->nports = 2;
>> -        break;
>> -    default:
>> -        omap->nports = OMAP3_HS_USB_PORTS;
>> -        dev_dbg(dev,
>> -          "USB HOST Rev : 0x%d not recognized, assuming %d ports\n",
>> -           omap->usbhs_rev, omap->nports);
>> -        break;
>> +    /*
>> +     * If platform data contains nports then use that
>> +     * else make out number of ports from USBHS revision
>> +     */
>> +    if (pdata->nports) {
>> +        omap->nports = pdata->nports;
>> +    } else {
>> +        switch (omap->usbhs_rev) {
>> +        case OMAP_USBHS_REV1:
>> +            omap->nports = 3;
>> +            break;
>> +        case OMAP_USBHS_REV2:
>> +            omap->nports = 2;
>> +            break;
>> +        default:
>> +            omap->nports = OMAP3_HS_USB_PORTS;
>> +            dev_dbg(dev,
>> +            "USB HOST Rev:0x%d not recognized, assuming %d ports\n",
> 
>    Please indent the string to the right somewhat, as it was before.
> 

OK. I will fix it in the pull request e-mail that i'll send in a while
as a reply to the first message in this patchset.

--
cheers,
-roger
