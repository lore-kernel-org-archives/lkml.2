Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab2IUVSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 17:18:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47474 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab2IUVSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 17:18:09 -0400
Message-ID: <505CD986.1050502@gmail.com>
Date: Fri, 21 Sep 2012 23:17:58 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: linux-next: Tree for Sept 21 (misc/lis3lv02d DT code)
References: <20120921170139.4f0d85b1b733b37757a1f75b@canb.auug.org.au> <505CA874.3050803@xenotime.net>
In-Reply-To: <505CA874.3050803@xenotime.net>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/mixed;
 boundary="------------010907040800010701030900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010907040800010701030900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 21.09.2012 19:48, Randy Dunlap wrote:
> On 09/21/2012 12:01 AM, Stephen Rothwell wrote:
> 
>> Hi all,
>>
>> Changes since 201209020:
>>
> 
> 
> 
> on i386:
> 
> ERROR: "lis3lv02d_init_dt" [drivers/misc/lis3lv02d/lis3lv02d_i2c.ko] undefined!
> 
> Full randconfig file is attached.
> 

Hmm, I cannot reproduce that on my machine with your config, but the
attached patch should fix it.

Andrew, you already have a patch queued up for this driver - could you
fold that one maybe after Randy signals success?


Thanks,
Daniel


--------------010907040800010701030900
Content-Type: text/x-patch;
 name="0001-misc-lis3-fix-undefined-reference-to-lis3lv02d_init_.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-misc-lis3-fix-undefined-reference-to-lis3lv02d_init_.pa";
 filename*1="tch"

>From 7b3210ec41a40f2b667f57eb4478eb5a149199c8 Mon Sep 17 00:00:00 2001
From: Daniel Mack <zonque@gmail.com>
Date: Fri, 21 Sep 2012 23:14:29 +0200
Subject: [PATCH] misc: lis3: fix undefined reference to lis3lv02d_init_dt

Export the symbol to fix linker errors.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/misc/lis3lv02d/lis3lv02d.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index 026021e..f9c24ab 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -1089,6 +1089,7 @@ int lis3lv02d_init_dt(struct lis3lv02d *lis3)
 	return 0;
 }
 #endif
+EXPORT_SYMBOL_GPL(lis3lv02d_init_dt);
 
 /*
  * Initialise the accelerometer and the various subsystems.
-- 
1.7.11.4


--------------010907040800010701030900--
