Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab0KIQkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:40:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50284
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988Ab0KIQkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:40:20 -0500
Date: Tue, 09 Nov 2010 08:40:45 -0800 (PST)
Message-Id: <20101109.084045.104069884.davem@davemloft.net>
To: dave@gnu.org
Cc: robert.olsson@its.uu.se, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: replace min with min_t in pktgen_if_write
From: David Miller <davem@davemloft.net>
In-Reply-To: <1289320633.2260.12.camel@cowboy>
References: <1289320633.2260.12.camel@cowboy>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oA9Ged1W023901

From: Davidlohr Bueso <dave@gnu.org>
Date: Tue, 09 Nov 2010 13:37:13 -0300

> From: Davidlohr Bueso <dave@gnu.org>
> 
> This addresses the following compiler (gcc 4.4.5) warning:
> 
>   CC [M]  net/core/pktgen.o
> net/core/pktgen.c: In function ¡pktgen_if_write¢:
> net/core/pktgen.c:890: warning: comparison of distinct pointer types lacks a cast
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>

Already fixed in net-2.6:

commit 86c2c0a8a4965ae5cbc0ff97ed39a4472e8e9b23
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Sat Nov 6 20:11:38 2010 +0000

    NET: pktgen - fix compile warning
    
    This should fix the following warning:
    
    net/core/pktgen.c: In function ¡pktgen_if_write¢:
    net/core/pktgen.c:890: warning: comparison of distinct pointer types lacks a cast
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Reviewed-by: Nelson Elhage <nelhage@ksplice.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index fbce4b0..1992cd0 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -887,7 +887,7 @@ static ssize_t pktgen_if_write(struct file *file,
 	i += len;
 
 	if (debug) {
-		size_t copy = min(count, 1023);
+		size_t copy = min_t(size_t, count, 1023);
 		char tb[copy + 1];
 		if (copy_from_user(tb, user_buffer, copy))
 			return -EFAULT;
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
