Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab0I3Crh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:47:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34985
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752661Ab0I3Crg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:47:36 -0400
Date: Wed, 29 Sep 2010 19:47:56 -0700 (PDT)
Message-Id: <20100929.194756.02282581.davem@davemloft.net>
To: jgarzik@pobox.com
Cc: linux@rainbow-software.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] de2104x: disable media debug messages by default
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CA23941.2050803@pobox.com>
References: <201009282018.57547.linux@rainbow-software.org>
	<4CA23941.2050803@pobox.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jgarzik@pobox.com>
Date: Tue, 28 Sep 2010 14:51:45 -0400

> On 09/28/2010 02:18 PM, Ondrej Zary wrote:
>> Print media debug messages only when HW debug is enabled.
>>
>> Signed-off-by: Ondrej Zary<linux@rainbow-software.org>
>>
>> --- linux-2.6.36-rc3-/drivers/net/tulip/de2104x.c 2010-09-28
>> --- 19:50:51.000000000 +0200
>> +++ linux-2.6.36-rc3/drivers/net/tulip/de2104x.c 2010-09-28
>> 20:05:34.000000000 +0200
>> @@ -948,8 +948,9 @@ static void de_set_media (struct de_priv
>>   	else
>>   		macmode&= ~FullDuplex;
>>
>> -	if (netif_msg_link(de)) {
>> +	if (netif_msg_link(de))
>>   		dev_info(&de->dev->dev, "set link %s\n", media_name[media]);
>> +	if (netif_msg_hw(de)) {
>>   		dev_info(&de->dev->dev, "mode 0x%x, sia 0x%x,0x%x,0x%x,0x%x\n",
>>   			 dr32(MacMode), dr32(SIAStatus),
>>   			 dr32(CSR13), dr32(CSR14), dr32(CSR15));
> 
> Acked-by: Jeff Garzik <jgarzik@redhat.com>

Applied to net-next-2.6
