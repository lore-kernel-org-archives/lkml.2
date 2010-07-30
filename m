Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab0G3ARm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 20:17:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40973 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab0G3ARk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 20:17:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=swCX5PWvVTSSAmcLSpUvaljarpxxB600C2eSUv7HHwnofvNHFpmFVKHXVFnxu4Bn86
         J+zOsa0/DaJdCtgUqVz1adZMVpWUZIwh1XYqsqTcFI9STTL+X7nqXO86YpBgdg4TS0eq
         vd6cZK8y3LnsntX3dtfnIxbZUnYMCXYgteDtw=
MIME-Version: 1.0
In-Reply-To: <61ca890fdbff3397e15328685ba6d86eaabf8fec.1280447281.git.joe@perches.com>
References: <cover.1280447281.git.joe@perches.com> <61ca890fdbff3397e15328685ba6d86eaabf8fec.1280447281.git.joe@perches.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 29 Jul 2010 20:17:19 -0400
Message-ID: <AANLkTi=jTj7g7STZCTYYBsw5zmij3jmEedBoEnZE4TgW@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] drivers/net/bfin_mac.c: Use pr_<level>, 
	netdev_<level>
To: Joe Perches <joe@perches.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o6U0Hp6D009609

On Thu, Jul 29, 2010 at 19:58, Joe Perches wrote:
> Add and use pr_fmt, pr_<level> and netdev_<level>

your changelog says add pr_fmt, but i dont see it in the patch ...

> @@ -833,8 +830,7 @@ static void bfin_tx_hwtstamp(struct net_device *netdev, struct sk_buff *skb)
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  (--timeout_cnt))
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â udelay(1);
> Â  Â  Â  Â  Â  Â  Â  Â if (timeout_cnt == 0)
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  printk(KERN_ERR DRV_NAME
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  ": fails to timestamp the TX packet\n");
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  pr_err("failed to timestamp the TX packet\n");

this func has a net_device, so cant you use netdev_err here ?

> @@ -1102,8 +1097,7 @@ static void bfin_mac_rx(struct net_device *dev)
>
> Â  Â  Â  Â new_skb = dev_alloc_skb(PKT_BUF_SZ + NET_IP_ALIGN);
> Â  Â  Â  Â if (!new_skb) {
> - Â  Â  Â  Â  Â  Â  Â  printk(KERN_NOTICE DRV_NAME
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â ": rx: low on mem - packet dropped\n");
> + Â  Â  Â  Â  Â  Â  Â  pr_notice("rx: low on mem - packet dropped\n");

same here

otherwise this patch looks good
-mike
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
