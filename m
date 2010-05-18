Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab0ERFXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 01:23:05 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:38900 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab0ERFXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 01:23:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=OfPhH/pPhhlbpKPHQYZ0yAb3AnqYTIa2ROPbnnUYrW9dDT0TGkZTtqlj6UuQtPCbtX
         U8t+UGoGLZUkQ/lqold2KF3zu6wRoSoBaeK5yxtkGe3IDwgetMT0YtOhOk75nx8FP83Q
         uzVr1Bf0+52Xte5wdIv/fdYw+988mI+XGrnnU=
MIME-Version: 1.0
Date: Tue, 18 May 2010 13:23:01 +0800
Message-ID: <AANLkTikYvtfMgpXW5mGHmMDSoj9O0QKOMzspoDQHURxF@mail.gmail.com>
Subject: [PATCH] random: Check kmalloc return value and give the failed 
	message
From: Steven Liu <lingjiujianke@gmail.com>
To: mpm@selenic.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Matt Mackall,

Check kmalloc return value and give the failed message

Signed-off-by: Liu Qi <lingjiujianke@gmail.com>
---
 drivers/char/random.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 2fd3d39..d1bedeb 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -952,8 +952,11 @@ static void init_std_data(struct entropy_store *r)
    mix_pool_bytes(r, &now, sizeof(now));
    mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
    /* Enable continuous test in fips mode */
-   if (fips_enabled)
+   if (fips_enabled){
        r->last_data = kmalloc(EXTRACT_SIZE, GFP_KERNEL);
+       if(r->last_data == NULL)
+           printk(KERN_ERR "kmalloc memory failed in %s \n", __func__);
+   }
 }

 static int rand_initialize(void)
--
1.7.1



Best regards
