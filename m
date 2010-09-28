Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0I1RDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:03:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24915 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab0I1RDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:03:18 -0400
Date: Tue, 28 Sep 2010 09:58:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH -next] sound/soc: fix printk format warning
Message-Id: <20100928095846.9d4c7641.randy.dunlap@oracle.com>
In-Reply-To: <20100928141823.8c61000e.sfr@canb.auug.org.au>
References: <20100928141823.8c61000e.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix dev_printk format warning:

sound/soc/codecs/wm8985.c:731: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/soc/codecs/wm8985.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100927.orig/sound/soc/codecs/wm8985.c
+++ linux-next-20100927/sound/soc/codecs/wm8985.c
@@ -728,7 +728,7 @@ static int wm8985_hw_params(struct snd_p
 		return -EINVAL;
 	}
 
-	dev_dbg(dai->dev, "BCLK div = %d\n", i);
+	dev_dbg(dai->dev, "BCLK div = %zd\n", i);
 	snd_soc_update_bits(codec, WM8985_CLOCK_GEN_CONTROL,
 			    WM8985_BCLKDIV_MASK, i << WM8985_BCLKDIV_SHIFT);
 	return 0;
