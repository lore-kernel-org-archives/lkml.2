Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab1CSEk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 00:40:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58398 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1CSEku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 00:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=EtN7zVq9tn4ynItiB7F3ucfeE0E+SJk91Dha+d2xQrOdtCRQmm+T3rv53NCbhbcYOr
         /bp5WzWfE9fYSysSFmxm1Dq65eKlEcqz0u0fHHXeV9GfelfMklMxZTjOIKvsLFOxmcBC
         zxGInahRPfk/0J1lLFB8dUDcggO+dJfiUjPwc=
Date: Sat, 19 Mar 2011 07:40:32 +0300
From: Dan Carpenter <error27@gmail.com>
To: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] rapidio: potential null deref on failure path
Message-ID: <20110319044032.GC2008@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Alexandre Bounine <alexandre.bounine@idt.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If rio is not a switch then "rswitch" is null.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index a50391b..3a59d5f 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -517,7 +517,7 @@ static struct rio_dev __devinit *rio_setup_device(struct rio_net *net,
 	return rdev;
 
 cleanup:
-	if (rswitch->route_table)
+	if (rio_is_switch(rdev))
 		kfree(rswitch->route_table);
 
 	kfree(rdev);
