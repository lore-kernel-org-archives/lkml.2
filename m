Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0JOMJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:09:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:49975 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab0JOMJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:09:08 -0400
Message-ID: <4CB8445C.1060109@kernel.org>
Date: Fri, 15 Oct 2010 14:09:00 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2.6.36-rc7] crypto: use cancel_delayed_work_sync() in hifn_795x
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 12:09:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make hifn_795x::hifn_remove() call cancel_delayed_work_sync() instead
of calling cancel_delayed_work() followed by flush_scheduled_work().

This is to prepare for the deprecation and removal of
flush_scheduled_work().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/crypto/hifn_795x.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: work/drivers/crypto/hifn_795x.c
===================================================================
--- work.orig/drivers/crypto/hifn_795x.c
+++ work/drivers/crypto/hifn_795x.c
@@ -2700,8 +2700,7 @@ static void __devexit hifn_remove(struct
 	dev = pci_get_drvdata(pdev);

 	if (dev) {
-		cancel_delayed_work(&dev->work);
-		flush_scheduled_work();
+		cancel_delayed_work_sync(&dev->work);

 		hifn_unregister_rng(dev);
 		hifn_unregister_alg(dev);
