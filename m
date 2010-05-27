Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab0E0WkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:40:09 -0400
Received: from forward15.mail.yandex.net ([95.108.130.119]:39587 "EHLO
	forward15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab0E0WkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:40:06 -0400
From: Sergey Temerkhanov <temerkhanov@yandex.ru>
Organization: Cifronic ZAO
To: "linux-aio" <linux-aio@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 2/3] [RFC] AIO: Add aio_put_req() calls to io_cancel() and aio_cancel_all()
Date: Fri, 28 May 2010 02:35:20 +0400
User-Agent: KMail/1.12.4 (Linux/2.6.34-40-desktop; KDE/4.3.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005280235.20661.temerkhanov@yandex.ru>
X-Yandex-TimeMark: 1274999725
X-Yandex-Spam: 1
X-Yandex-Front: smtp11.mail.yandex.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sergey Temerkhanov<temerkhanov@cifronik.ru>

This patch fixes reference counting in aio_cancel_all()
and io_cancel()

diff -r 74c172a99cdb fs/aio.c
--- a/fs/aio.c	Tue Mar 16 18:55:59 2010 +0300
+++ b/fs/aio.c	Wed Mar 17 17:42:47 2010 +0300
@@ -1036,6 +1036,7 @@
 			cancel(iocb, &res);
 			spin_lock_irq(&ctx->ctx_lock);
 		}
+		__aio_put_req(ctx, iocb);
 	}
 	spin_unlock_irq(&ctx->ctx_lock);
 }
@@ -1792,6 +1793,7 @@
 	} else
 		ret = -EINVAL;
 
+	aio_put_req(kiocb);
 	put_ioctx(ctx);
 
 	return ret;
