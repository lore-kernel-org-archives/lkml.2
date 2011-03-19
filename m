Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab1CSEig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 00:38:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46078 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab1CSEi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 00:38:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=YUOv9bBSt8zzMQ3JnupYEFUBsbN4mns64FojBYSqzaCEBnZorUijt428xCPy4MrG2J
         tVSAA0HZyN+V19SosIpol4I4o3BXOB2WKNaHi2N0t2dmnsUfSzxsH27+H6OjD5JRxCwv
         P3cgG6hAbdArLYdF0U2X8+1dJwSaTzqVAOmns=
Date: Sat, 19 Mar 2011 07:38:13 +0300
From: Dan Carpenter <error27@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] vlynq: fix resource size calculation
Message-ID: <20110319043813.GA2008@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Florian Fainelli <florian@openwrt.org>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code had an off-by-one error so we didn't release the
entire memory region on remove().

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
index f885c86..1d37553 100644
--- a/drivers/vlynq/vlynq.c
+++ b/drivers/vlynq/vlynq.c
@@ -764,7 +764,7 @@ static int vlynq_remove(struct platform_device *pdev)
 
 	device_unregister(&dev->dev);
 	iounmap(dev->local);
-	release_mem_region(dev->regs_start, dev->regs_end - dev->regs_start);
+	release_mem_region(dev->regs_start, dev->regs_end - dev->regs_start + 1);
 
 	kfree(dev);
 
