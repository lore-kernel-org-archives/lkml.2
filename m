Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab1BVJWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 04:22:45 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:62163 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab1BVJWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 04:22:42 -0500
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Feb 2011 04:22:42 EST
Message-ID: <B2D7D72494BB443F80DA08E22323999B@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Sergei Shtylyov" <sshtylyov@mvista.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Russell King" <linux@arm.linux.org.uk>,
        "Kevin Hilman" <khilman@deeprootsystems.com>, <nsekhar@ti.com>,
        "open list" <linux-kernel@vger.kernel.org>, <m-watkins@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-13-git-send-email-subhasish@mistralsolutions.com> <4D55860E.3090908@mvista.com>
In-Reply-To: <4D55860E.3090908@mvista.com>
Subject: Re: [PATCH v2 12/13] da850: pruss SUART platform specific additions.
Date: Tue, 22 Feb 2011 14:48:13 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I could not follow your recommendations clearly, are you suggesting this:

int __init da8xx_register_pruss(struct da8xx_pruss_devices *pruss_device)
{
#ifdef CONFIG_SERIAL_PRUSS_SUART_MODULE
        int ret;

        ret = clk_add_alias(NULL, "da8xx_pruss_uart.1",
                            NULL, &da850_mcasp_device.dev);
        if (ret < 0)
                return ret;
#endif
        da8xx_pruss_dev.dev.platform_data = pruss_device;
        return platform_device_register(&da8xx_pruss_dev);
}

--------------------------------------------------
From: "Sergei Shtylyov" <sshtylyov@mvista.com>
Sent: Saturday, February 12, 2011 12:25 AM
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>; 
<sachi@mistralsolutions.com>; "Russell King" <linux@arm.linux.org.uk>; 
"Kevin Hilman" <khilman@deeprootsystems.com>; <nsekhar@ti.com>; "open list" 
<linux-kernel@vger.kernel.org>; <m-watkins@ti.com>; 
<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 12/13] da850: pruss SUART platform specific 
additions.

> Subhasish Ghosh wrote:
>
>> This patch adds the McASP clock alias.
>> The alias is used by the pruss suart driver
>> for enabling the McASP PSC.
>
>> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
> [...]
>
>> diff --git a/arch/arm/mach-davinci/devices-da8xx.c 
>> b/arch/arm/mach-davinci/devices-da8xx.c
>> index e15de72..f1cf605 100644
>> --- a/arch/arm/mach-davinci/devices-da8xx.c
>> +++ b/arch/arm/mach-davinci/devices-da8xx.c
>> @@ -560,7 +560,18 @@ struct platform_device da8xx_pruss_dev = {
>>  int __init da8xx_register_pruss(struct da8xx_pruss_devices 
>> *pruss_device)
>>  {
>> +#ifdef CONFIG_SERIAL_PRUSS_SUART_MODULE
>
>    #ifdef's in the function body are generally fromned upon.
>
>> + int ret;
>> +#endif
>> +
>
>    This line should have been inside #ifdef...
>
>>  da8xx_pruss_dev.dev.platform_data = pruss_device;
>> +
>> +#ifdef CONFIG_SERIAL_PRUSS_SUART_MODULE
>
>    Why not do it before assigning the platform data and avoid extra 
> #ifdef?
>
>> + ret = clk_add_alias(NULL, "da8xx_pruss_uart.1",
>> + NULL, &da850_mcasp_device.dev);
>
>    This line should be indented more to the right.
>
>> + if (ret < 0)
>> + return ret;
>> +#endif
>
> WBR, Sergei 

