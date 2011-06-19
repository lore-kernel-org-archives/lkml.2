Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab1FSSnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 14:43:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51786 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab1FSSnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 14:43:51 -0400
MIME-Version: 1.0
In-Reply-To: <4DFE111B.8010001@gmail.com>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org>
 <1308410354-21387-3-git-send-email-shawn.guo@linaro.org> <4DFDDFF4.8000305@snapgear.com>
 <201106191411.32137.arnd@arndb.de> <4DFE111B.8010001@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 19 Jun 2011 12:43:30 -0600
X-Google-Sender-Auth: BG_0r2E5iCFs87ptbks22ZDfcoE
Message-ID: <BANLkTinbPGMyBxK+zo6ZtFhisSSkU7daYA@mail.gmail.com>
Subject: Re: [PATCH 2/3] net/fec: add device tree support
To: Rob Herring <robherring2@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Greg Ungerer <gerg@snapgear.com>,
        patches@linaro.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Jason Liu <jason.hui@linaro.org>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 9:09 AM, Rob Herring <robherring2@gmail.com> wrote:
> On 06/19/2011 07:11 AM, Arnd Bergmann wrote:
>> On Sunday 19 June 2011 13:39:32 Greg Ungerer wrote:
>>>> +#ifdef CONFIG_OF
>>>> +static const struct of_device_id fec_dt_ids[] = {
>>>> +     { .compatible = "fsl,fec", .data =&fec_devtype[0], },
>>>> +     {},
>>>> +};
>>>> +
>>>> +static const struct of_device_id *
>>>> +fec_get_of_device_id(struct platform_device *pdev)
>>>> +{
>>>> +     return of_match_device(fec_dt_ids,&pdev->dev);
>>>> +}
>>>> +#else
>>>> +#define fec_dt_ids NULL
>>>> +static inline struct of_device_id *
>>>> +fec_get_of_device_id(struct platform_device *pdev)
>>>> +{
>>>> +     return NULL;
>>>> +}
>>>> +#endif
>>>> +
>>>>   static unsigned char macaddr[ETH_ALEN];
>>>>   module_param_array(macaddr, byte, NULL, 0);
>>>>   MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
>>>> @@ -1363,6 +1385,11 @@ fec_probe(struct platform_device *pdev)
>>>>       struct net_device *ndev;
>>>>       int i, irq, ret = 0;
>>>>       struct resource *r;
>>>> +     const struct of_device_id *of_id;
>>>> +
>>>> +     of_id = fec_get_of_device_id(pdev);
>>>
>>> fec_get_of_device_id() is defined inside of "#ifdef CONFIG_OF". This
>>> use of it will break compilation when this is not defined.
>>>
>>
>>
>> Why? Note the #else path defining an empty function.
>>
>
> None of this is necessary in the first place. Just call of_match_device
> directly. There is already an empty function to return NULL when
> CONFIG_OF is not defined.

Heh, right you are.  I should have caught on to that.  :-)

g.
