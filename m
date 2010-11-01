Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482Ab0KAQWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 12:22:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60933
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755595Ab0KAQWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 12:22:23 -0400
Date: Mon, 01 Nov 2010 09:22:46 -0700 (PDT)
Message-Id: <20101101.092246.104046133.davem@davemloft.net>
To: mirqus@gmail.com
Cc: mad_soft@inbox.ru, linux-usb@vger.kernel.org,
        dbrownell@users.sourceforge.net, gregkh@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        therbert@google.com
Subject: Re: [PATCH] USB: gadget: fix ethernet gadget crash in gether_setup
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTimMwTbj-2oP-VP7Ht1VnA8_w7vpTGz1kk5HG7zx@mail.gmail.com>
References: <1288253909-12084-1-git-send-email-mad_soft@inbox.ru>
	<AANLkTimMwTbj-2oP-VP7Ht1VnA8_w7vpTGz1kk5HG7zx@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oA1GMeWo012562

From: MichaÅ‚ MirosÅ‚aw <mirqus@gmail.com>
Date: Mon, 1 Nov 2010 17:16:39 +0100

> 2010/10/28 Dmitry Artamonow <mad_soft@inbox.ru>:
>> Crash is triggered by commit e6484930d7 ("net: allocate tx queues in
>> register_netdevice"), which moved tx netqueue creation into register_netdev.
>> So now calling netif_stop_queue() before register_netdev causes an oops.
>> Move netif_stop_queue() after net device registration to fix crash.
>>
>> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
>> ---
>> Â drivers/usb/gadget/u_ether.c | Â  Â 2 +-
>> Â 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
>> index 6bb876d..cb23355 100644
>> --- a/drivers/usb/gadget/u_ether.c
>> +++ b/drivers/usb/gadget/u_ether.c
>> @@ -797,7 +797,6 @@ int gether_setup(struct usb_gadget *g, u8 ethaddr[ETH_ALEN])
>> Â  Â  Â  Â  * Â - iff DATA transfer is active, carrier is "on"
>> Â  Â  Â  Â  * Â - tx queueing enabled if open *and* carrier is "on"
>> Â  Â  Â  Â  */
>> - Â  Â  Â  netif_stop_queue(net);
>> Â  Â  Â  Â netif_carrier_off(net);
>>
>> Â  Â  Â  Â dev->gadget = g;
>> @@ -812,6 +811,7 @@ int gether_setup(struct usb_gadget *g, u8 ethaddr[ETH_ALEN])
>> Â  Â  Â  Â  Â  Â  Â  Â INFO(dev, "MAC %pM\n", net->dev_addr);
>> Â  Â  Â  Â  Â  Â  Â  Â INFO(dev, "HOST MAC %pM\n", dev->host_mac);
>>
>> + Â  Â  Â  Â  Â  Â  Â  netif_stop_queue(net);
>> Â  Â  Â  Â  Â  Â  Â  Â the_dev = dev;
>> Â  Â  Â  Â }
>>
> 
> What about a race between register_netdev() -> open() -> rest of
> gether_setup() ? What is this netif_stop_queue() here needed for?

Nothing, it should be completely removed.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
