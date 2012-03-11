Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab2CKVQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 17:16:36 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:29524 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751412Ab2CKVQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 17:16:28 -0400
X-IronPort-AV: E=Sophos;i="4.73,566,1325458800"; 
   d="scan'208";a="148736515"
Date: Sun, 11 Mar 2012 22:16:25 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: "Chas Williams (CONTRACTOR)" <chas@cmf.nrl.navy.mil>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] drivers/atm/eni.c: ensure arguments to request_irq
 and free_irq are compatible
In-Reply-To: <201203112058.q2BKwBCS024617@cmf.nrl.navy.mil>
Message-ID: <alpine.DEB.2.02.1203112215250.1958@localhost6.localdomain6>
References: <201203112058.q2BKwBCS024617@cmf.nrl.navy.mil>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Convert calls to free_irq so that the second argument is the same as the
last argument of the corresponding call to request_irq.  Without this
property, free_irq does nothing.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Version 2: change free_irq, not request_irq.

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 956e9ac..485a11a 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -1873,7 +1873,7 @@ free_list:
  	kfree(eni_dev->free_list);

  free_irq:
-	free_irq(eni_dev->irq, eni_dev);
+	free_irq(eni_dev->irq, dev);

  out:
  	return error;
