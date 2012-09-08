Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2IHKpB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 06:45:01 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52494 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab2IHKo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 06:44:59 -0400
Message-ID: <504B21A3.3070401@gmail.com>
Date: Sat, 08 Sep 2012 12:44:51 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-next@vger.kernel.org, Daniel Mack <daniel@caiaq.de>
Subject: Re: mmotm 2012-09-06-16-46 uploaded (drivers/misc/lis3lv02d/lis3lv02d_spi.c)
References: <20120906234735.1B54B20004E@hpza10.eem.corp.google.com> <504A9644.4070303@xenotime.net>
In-Reply-To: <504A9644.4070303@xenotime.net>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/mixed;
 boundary="------------070801020902000604080303"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070801020902000604080303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 08.09.2012 02:50, Randy Dunlap wrote:
> On 09/06/2012 04:47 PM, akpm@linux-foundation.org wrote:
> 
>> The mm-of-the-moment snapshot 2012-09-06-16-46 has been uploaded to
>>
>>    http://www.ozlabs.org/~akpm/mmotm/
>>
> 
> 
> 
> on x86_64:
> 
> CONFIG_OF and CONFIG_DTC are not enabled.
> 
> 
> drivers/misc/lis3lv02d/lis3lv02d_spi.c:137:3: error: implicit declaration of function 'of_match_ptr'
> drivers/misc/lis3lv02d/lis3lv02d_spi.c:137:3: error: initializer element is not constant
> drivers/misc/lis3lv02d/lis3lv02d_spi.c:137:3: error: (near initialization for 'lis302dl_spi_driver.driver.of_match_table')
> 
> 

Thanks - the attached patch fixes it.

Daniel


--------------070801020902000604080303
Content-Type: text/x-patch;
 name="0001-lis3-lis3lv02d_spi.c-include-linux-of.h.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-lis3-lis3lv02d_spi.c-include-linux-of.h.patch"

>From 3c415511cb825d5b5d015b716e14d720a3d56bf6 Mon Sep 17 00:00:00 2001
From: Daniel Mack <zonque@gmail.com>
Date: Sat, 8 Sep 2012 12:41:33 +0200
Subject: [PATCH] lis3: lis3lv02d_spi.c: include linux/of.h

This include is needed to define of_match:ptr() for !CONFIG_OF &&
1CONFIG_DTC.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/misc/lis3lv02d/lis3lv02d_spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/lis3lv02d/lis3lv02d_spi.c b/drivers/misc/lis3lv02d/lis3lv02d_spi.c
index 8616054..23f3986 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d_spi.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d_spi.c
@@ -17,6 +17,7 @@
 #include <linux/workqueue.h>
 #include <linux/spi/spi.h>
 #include <linux/pm.h>
+#include <linux/of.h>
 #include <linux/of_platform.h>
 
 #include "lis3lv02d.h"
-- 
1.7.11.4


--------------070801020902000604080303--
