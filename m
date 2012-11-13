Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab2KMNOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:14:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:46585 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab2KMNOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:14:52 -0500
Date: Tue, 13 Nov 2012 11:14:40 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20121113111440.4a3435b3@infradead.org>
In-Reply-To: <20121112110935.eee5f582f16ab07c9faeabb1@canb.auug.org.au>
References: <20121112110935.eee5f582f16ab07c9faeabb1@canb.auug.org.au>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 12 Nov 2012 11:09:35 +1100
Stephen Rothwell <sfr@canb.auug.org.au> escreveu:

> Hi Mauro,
> 
> After merging the v4l-dvb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "sms_ir_exit" [drivers/media/common/siano/smsmdtv.ko] undefined!
> ERROR: "sms_ir_event" [drivers/media/common/siano/smsmdtv.ko] undefined!
> ERROR: "sms_ir_init" [drivers/media/common/siano/smsmdtv.ko] undefined!
> 
> This is better than Friday, but still not quite there. :-(
> 
> I have used the v4l-dvb tree from next-20121026 again.

Sorry, I did one mistake on my last patch. Instead of adding RC to the
siano core, it was added at the build as if it was an independent module.

The fix is trivial. I'll add it on my tree for tomorrow's merge.

Thanks for pointing it.

Regards,
Mauro

-

[PATCH] [media] siano: fix build with allmodconfig

As reported by Stephen:

	After merging the v4l-dvb tree, today's linux-next build (x86_64
	allmodconfig) failed like this:

	ERROR: "sms_ir_exit" [drivers/media/common/siano/smsmdtv.ko] undefined!
	ERROR: "sms_ir_event" [drivers/media/common/siano/smsmdtv.ko] undefined!
	ERROR: "sms_ir_init" [drivers/media/common/siano/smsmdtv.ko] undefined!

The smsir file should be part of the smsmdtv core, if RC is defined.
Fix it.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/siano/Makefile b/drivers/media/common/siano/Makefile
index 9e7fdf2..81b1e98 100644
--- a/drivers/media/common/siano/Makefile
+++ b/drivers/media/common/siano/Makefile
@@ -3,7 +3,7 @@ smsmdtv-objs := smscoreapi.o sms-cards.o smsendian.o
 obj-$(CONFIG_SMS_SIANO_MDTV) += smsmdtv.o smsdvb.o
 
 ifeq ($(CONFIG_SMS_SIANO_RC),y)
-  obj-$(CONFIG_SMS_SIANO_MDTV) += smsir.o
+  smsmdtv-objs += smsir.o
 endif
 
 ccflags-y += -Idrivers/media/dvb-core
