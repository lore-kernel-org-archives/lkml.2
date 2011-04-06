Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab1DFURe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:17:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52961 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab1DFURb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:17:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=tbBnCp8fMp7vVqT+uOGTecnoLNCEdtRJlbrcj5n3mTGsS3XtznJxcwBPLjSPnt+9DW
         jAtD8FdRKQHImF5YNKOI7COAQ1uGsb9Rka/VSJun6Cy8xj20da6L2M/jz01yK5hOlq+e
         Aminri+P+rAubAx70h0nVGrUEnxgD39m1fhoA=
Subject: Re: Linux 2.6.39-rc2
From: weltall <weltall2@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 22:17:27 +0200
Message-ID: <1302121047.11467.82.camel@portatile>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like there is an issue with building a driver in staging

  LD [M]  drivers/staging/hv/hv_netvsc.o
  LD [M]  drivers/staging/hv/hv_utils.o
  CC [M]  drivers/staging/hv/hv_mouse.o
drivers/staging/hv/hv_mouse.c: In function ‘ReleaseInputDevice’:
drivers/staging/hv/hv_mouse.c:293: error: implicit declaration of
function ‘udelay’
make[4]: *** [drivers/staging/hv/hv_mouse.o] Error 1
make[3]: *** [drivers/staging/hv] Error 2
make[2]: *** [drivers/staging] Error 2

Seems to be just a missing header in drivers/staging/hv/hv_mouse.c (to
be precise linux/delay.h as the file uses udelay()) this patch fixes the
issue:

--- drivers/staging/hv/hv_mouse.c	2011-04-06 20:46:22.000000000 +0200
+++ drivers/staging/hv/hv_mouse.c	2011-04-06 20:46:54.000000000 +0200
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/delay.h>
 #include <linux/workqueue.h>
 #include <linux/sched.h>
 #include <linux/wait.h>

regards, Stefano Angeleri

