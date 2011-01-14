Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1ANFuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 00:50:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49940
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752375Ab1ANFt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 00:49:56 -0500
Date: Thu, 13 Jan 2011 21:50:28 -0800 (PST)
Message-Id: <20110113.215028.237355303.davem@davemloft.net>
To: jj@chaosbits.net
Cc: linux-kernel@vger.kernel.org, oliver@neukum.name, gregkh@suse.de,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        alexey.orishko@stericsson.com, hans.petter.selasky@stericsson.com
Subject: Re: [PATCH] USB CDC NCM: Don't deref NULL in cdc_ncm_rx_fixup()
 and don't use uninitialized variable.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1101132229260.11347@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101132229260.11347@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0E5oA1M002803

From: Jesper Juhl <jj@chaosbits.net>
Date: Thu, 13 Jan 2011 22:40:11 +0100 (CET)

> skb_clone() dynamically allocates memory and may fail. If it does it 
> returns NULL. This means we'll dereference a NULL pointer in 
> drivers/net/usb/cdc_ncm.c::cdc_ncm_rx_fixup().
> As far as I can tell, the proper way to deal with this is simply to goto 
> the error label.
> 
> Furthermore gcc complains that 'skb' may be used uninitialized:
>   drivers/net/usb/cdc_ncm.c: In function ¡cdc_ncm_rx_fixup¢:
>   drivers/net/usb/cdc_ncm.c:922:18: warning: ¡skb¢ may be used uninitialized in this function
> and I believe it is right. On the line where we
>   pr_debug("invalid frame detected (ignored)" ...
> we are using the local variable 'skb' but nothing has ever been assigned 
> to that variable yet. I believe the correct fix for that is to use 
> 'skb_in' instead.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
