Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1FSPJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 11:09:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50431 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab1FSPJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 11:09:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=n7DgIlY08R9b+pRRqmAok0pmvBr933qHTuHiNv884skJWq8BPelkpX33dV3rIrKVwR
         fCM0hOY4uE0Z6hVrDEHGn7PcuT1EYBH1DsqIn3PxHPshbxdMtnJ+Ft4u76iK7zKXMcoJ
         MOT74FDBcSY/rYfWjdsbMMihyjYIZoQsxio30=
Message-ID: <4DFE111B.8010001@gmail.com>
Date: Sun, 19 Jun 2011 10:09:15 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, Greg Ungerer <gerg@snapgear.com>,
        patches@linaro.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Jason Liu <jason.hui@linaro.org>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/3] net/fec: add device tree support
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org>	<1308410354-21387-3-git-send-email-shawn.guo@linaro.org>	<4DFDDFF4.8000305@snapgear.com> <201106191411.32137.arnd@arndb.de>
In-Reply-To: <201106191411.32137.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2011 07:11 AM, Arnd Bergmann wrote:
> On Sunday 19 June 2011 13:39:32 Greg Ungerer wrote:
>>> +#ifdef CONFIG_OF
>>> +static const struct of_device_id fec_dt_ids[] = {
>>> +     { .compatible = "fsl,fec", .data =&fec_devtype[0], },
>>> +     {},
>>> +};
>>> +
>>> +static const struct of_device_id *
>>> +fec_get_of_device_id(struct platform_device *pdev)
>>> +{
>>> +     return of_match_device(fec_dt_ids,&pdev->dev);
>>> +}
>>> +#else
>>> +#define fec_dt_ids NULL
>>> +static inline struct of_device_id *
>>> +fec_get_of_device_id(struct platform_device *pdev)
>>> +{
>>> +     return NULL;
>>> +}
>>> +#endif
>>> +
>>>   static unsigned char macaddr[ETH_ALEN];
>>>   module_param_array(macaddr, byte, NULL, 0);
>>>   MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
>>> @@ -1363,6 +1385,11 @@ fec_probe(struct platform_device *pdev)
>>>       struct net_device *ndev;
>>>       int i, irq, ret = 0;
>>>       struct resource *r;
>>> +     const struct of_device_id *of_id;
>>> +
>>> +     of_id = fec_get_of_device_id(pdev);
>>
>> fec_get_of_device_id() is defined inside of "#ifdef CONFIG_OF". This
>> use of it will break compilation when this is not defined.
>>
> 
> 
> Why? Note the #else path defining an empty function.
> 

None of this is necessary in the first place. Just call of_match_device
directly. There is already an empty function to return NULL when
CONFIG_OF is not defined.

Rob
