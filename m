Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab2B0SZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:25:41 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:39956 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754522Ab2B0SZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:25:39 -0500
Message-ID: <4F4BCAA5.8060308@xenotime.net>
Date: Mon, 27 Feb 2012 10:25:41 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] rtc: fix rtc-ds1307 printk format warning
References: <20120227182029.545a7db32550ce94c9faffb4@canb.auug.org.au>
In-Reply-To: <20120227182029.545a7db32550ce94c9faffb4@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning:

drivers/rtc/rtc-ds1307.c:915:3: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Alessandro Zummo <a.zummo@towertech.it>
Cc:	rtc-linux@googlegroups.com
---
 drivers/rtc/rtc-ds1307.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120227.orig/drivers/rtc/rtc-ds1307.c
+++ linux-next-20120227/drivers/rtc/rtc-ds1307.c
@@ -912,7 +912,7 @@ read_rtc:
 			goto exit_nvram;
 		}
 		set_bit(HAS_NVRAM, &ds1307->flags);
-		dev_info(&client->dev, "%d bytes nvram\n", ds1307->nvram->size);
+		dev_info(&client->dev, "%zu bytes nvram\n", ds1307->nvram->size);
 	}
 
 	return 0;
