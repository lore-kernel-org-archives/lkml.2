Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab0HIHo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 03:44:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53228
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484Ab0HIHoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 03:44:55 -0400
Date: Mon, 09 Aug 2010 00:45:14 -0700 (PDT)
Message-Id: <20100809.004514.73697921.davem@davemloft.net>
To: segooon@gmail.com
CC: herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: n2 RNG driver bogus cast removal
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o797j3TF018080


Kulikov, can you at least build test your patches?  Casts are not
always incorrect, particularly when private cookies are "unsigned
long" as is the case here:

drivers/char/hw_random/n2-drv.c: In function ¡n2rng_data_read¢:
drivers/char/hw_random/n2-drv.c:390: warning: initialization makes pointer from integer without a cast

Herbert, please revert this change, thanks.  And I suspect there
might be more of these hwrng driver duds that went into the tree,
it's worth checking out. :-)

Thanks.

commit 8b9cfdca9c52f7d39c3ccfac1668e31c20c9f42e
Author: Kulikov Vasiliy <segooon@gmail.com>
Date:   Mon Jul 5 21:25:06 2010 +0800

    hwrng: n2-drv - remove casts from void*
    
    Remove unnesessary casts from void*.
    
    Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
