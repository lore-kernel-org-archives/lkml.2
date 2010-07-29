Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab0G2Iup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:50:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64309 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab0G2Iul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:50:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=oBlotbdo7hApPcQtl7DAu46u6Cl8+Kqatahhrh4FfDgTvp007Sq6ILGt6UiCZE1O2M
         +iixfIyK9WH9gEUE9FULy8UpD+5Y+abtGyi5mQvyuRT/k1QWKj9IlYZ9m+qE9PxQO7Rn
         ulkpVgXGctjJojBO7Okvjn3T73hO0ymUHlFPU=
Date: Thu, 29 Jul 2010 10:50:14 +0200
From: Dan Carpenter <error27@gmail.com>
To: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] tmp_atmel: request correct region
Message-ID: <20100729085014.GT26313@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Debora Velarde <debora@linux.vnet.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	Marcel Selhorst <m.selhorst@sirrix.com>,
	tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We wanted to request "base".  "tpm_atmel.base" is zero here.  This bug
was introduced by e0dd03caf20d "[PATCH] tpm: return chip from
tpm_register_hardware".

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Found with a static checker.  I don't have the hardware to test this.

diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
index c64a1bc..090b3ec 100644
--- a/drivers/char/tpm/tpm_atmel.c
+++ b/drivers/char/tpm/tpm_atmel.c
@@ -205,7 +205,7 @@ static int __init init_atmel(void)
 
 	have_region =
 	    (atmel_request_region
-	     (tpm_atmel.base, region_size, "tpm_atmel0") == NULL) ? 0 : 1;
+	     (base, region_size, "tpm_atmel0") == NULL) ? 0 : 1;
 
 	pdev = platform_device_register_simple("tpm_atmel", -1, NULL, 0);
 	if (IS_ERR(pdev)) {
