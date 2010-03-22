Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab0CVMKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:10:46 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36077 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab0CVMKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=oNKfz0g4Mu/YmRDROiKieniV319lxeCvxQrv5kXtQxEP8O4JgVoCI/pwuchiq98wft
         ZMV70S9MJJQX3VXwwp2pxi+osj6bLUaiIToD6rdbzvDCwaN3eNEUKPDsyjcPJHadTPKl
         gBmt51IilvSHQ7q/PpeK1S2whdPCd0zvRoWjM=
Date: Mon, 22 Mar 2010 15:10:35 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jun Nie <njun@marvell.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Lennert Buytenhek <buytenh@marvell.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>, Kevin Liu <kliu5@marvell.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] pxa168fb: use resource_size()
Message-ID: <20100322121034.GI21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Jun Nie <njun@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
	Lennert Buytenhek <buytenh@marvell.com>,
	Krzysztof Helt <krzysztof.h1@wp.pl>, Kevin Liu <kliu5@marvell.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size calculation is not correct.  It should be end - start + 1.
Use resource_size() to caculate it.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
This was found by a static checker and I don't have the hardware to
test it.  Please review carefully.

diff --git a/drivers/video/pxa168fb.c b/drivers/video/pxa168fb.c
index 75285d3..c91a7f7 100644
--- a/drivers/video/pxa168fb.c
+++ b/drivers/video/pxa168fb.c
@@ -668,7 +668,7 @@ static int __init pxa168fb_probe(struct platform_device *pdev)
 	/*
 	 * Map LCD controller registers.
 	 */
-	fbi->reg_base = ioremap_nocache(res->start, res->end - res->start);
+	fbi->reg_base = ioremap_nocache(res->start, resource_size(res));
 	if (fbi->reg_base == NULL) {
 		ret = -ENOMEM;
 		goto failed;
