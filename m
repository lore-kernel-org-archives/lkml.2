Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014Ab0HNJCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 05:02:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60799 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933509Ab0HNJCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 05:02:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=NEdqJ+BDhNZQsGpRr5V/bEGFQ5xndTTyLQuQCIKxLLOeU4EJISbUsrHdm/oCIA8BJN
         f0DEz9JETFRD+6PxdbrSmqww/e08qBlEDHCnzEtYRSwOwKB1PZuAhrikTuQgXr66NvlH
         l25g8pPKgDM+4YZUGuqy/zhhgmLbZ9TX6Ipa0=
Date: Sat, 14 Aug 2010 11:01:45 +0200
From: Dan Carpenter <error27@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Magnus Damm <damm@opensource.se>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] dma/shdma: move dereference below the NULL check
Message-ID: <20100814090145.GW645@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Paul Mundt <lethal@linux-sh.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <damm@opensource.se>,
	Linus Walleij <linus.walleij@stericsson.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"param" can be NULL here, so only dereference it after the check.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index fb64cf3..eb6b54d 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -580,7 +580,6 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_slave_sg(
 
 	sh_chan = to_sh_chan(chan);
 	param = chan->private;
-	slave_addr = param->config->addr;
 
 	/* Someone calling slave DMA on a public channel? */
 	if (!param || !sg_len) {
@@ -589,6 +588,8 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_slave_sg(
 		return NULL;
 	}
 
+	slave_addr = param->config->addr;
+
 	/*
 	 * if (param != NULL), this is a successfully requested slave channel,
 	 * therefore param->config != NULL too.
