Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0CQMkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 08:40:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35867 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab0CQMkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 08:40:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=VO92dGXQ2TsuT0I8yrHsnxNzXjKTOufzcWKbd86yWNi+WIPnOM09kBXWMt5YOunWPH
         9B559uO0jPdhR/fq5wpdMnY4c5GMz2MbFuIbcl5Fk9wc4dWOwxA6BFPsltblVyA+pxdj
         ZCojp98QCbAzrrMHrPIMEkKipwkE65qgf8avE=
Subject: Re: [PATCH] drivers/net/wimax/i2400m/fw.c fix possible double free
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
       kernel-janitors@vger.kernel.org, cindy.h.kao@intel.com,
       dirk.j.brandewie@intel.com, wimax@linuxwimax.org,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 23:40:38 +1100
Message-ID: <1268829638.10618.28.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Mar 17, 2010 at 8:14 AM, David Miller <davem@davemloft.net>
wrote:

> Therefore the krealloc() failure handling in this driver should NULL
> out i2400m->fw_hdrs and that will fix the double kfree problem as well
> as trap any stray references.

Yes that is a much better Idea. Thanks for the advice. 
It also fixes the i2400m_barker_db problem that I didn't notice before.


Fix double free on krealloc() failure by zeroing pointer

coverity CID: 13455

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
---
 drivers/net/wimax/i2400m/fw.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/net/wimax/i2400m/fw.c
index 25c24f0..9f3b594 100644
--- a/drivers/net/wimax/i2400m/fw.c
+++ b/drivers/net/wimax/i2400m/fw.c
@@ -232,8 +232,9 @@ int i2400m_zrealloc_2x(void **ptr, size_t *_count, size_t el_size,
 		*_count = new_count;
 		*ptr = nptr;
 		return 0;
-	} else
-		return -ENOMEM;
+	}
+	*ptr = NULL;
+	return -ENOMEM;
 }
 
 
-- 
1.6.3.3

 




