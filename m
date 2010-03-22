Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0CVMKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:10:13 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54062 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab0CVMKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:10:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=vxh3gCfOdyOdPaALxDu2KWQTlC/J1qU+q+xUumi86i692VNW8fqg1tU6fuzItUEQjr
         5zyCbz/XjOxYuhrkpbWXJ/MKDgzZrd94pSNDIQue91ZRidedNl0OnIZTgZ1+kVpoU1UG
         /S+D8i2pikInmjN9pCF6+ODAMv2AxiZ6/bixY=
Date: Mon, 22 Mar 2010 15:09:59 +0300
From: Dan Carpenter <error27@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [patch] hdpuftrs: use resource_size()
Message-ID: <20100322120959.GH21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size caculation is wrong.  It should be end - start + 1.
Use resource_size() to calculate it correctly.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/misc/hdpuftrs/hdpu_nexus.c b/drivers/misc/hdpuftrs/hdpu_nexus.c
index ce39fa5..bce5029 100644
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c
+++ b/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -92,8 +92,7 @@ static int hdpu_nexus_probe(struct platform_device *pdev)
 		       "Invalid memory resource.\n");
 		return -EINVAL;
 	}
-	nexus_id_addr = ioremap(res->start,
-				(unsigned long)(res->end - res->start));
+	nexus_id_addr = ioremap(res->start, resource_size(res));
 	if (nexus_id_addr) {
 		slot_id = (*nexus_id_addr >> 8) & 0x1f;
 		chassis_id = *nexus_id_addr & 0xff;
