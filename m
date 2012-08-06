Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab2HFSbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:31:22 -0400
Received: from www17.your-server.de ([213.133.104.17]:47694 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879Ab2HFSbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:31:21 -0400
Subject: [PATCH] ASoC: Use PTR_RET rather than if(IS_ERR(.. [1]
From: Thomas Meyer <thomas@m3y3r.de>
To: "[lrg@ti.com, broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de, linux-kernel@vger.kernel.org]"@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Mon, 06 Aug 2012 19:51:17 +0200
Message-ID: <1344275477.14513.121.camel@localhost.localdomain>
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/ptr_ret.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/sound/soc/soc-io.c b/sound/soc/soc-io.c
--- a/sound/soc/soc-io.c
+++ b/sound/soc/soc-io.c
@@ -158,10 +158,7 @@ int snd_soc_codec_set_cache_io(struct sn
 		return -EINVAL;
 	}
 
-	if (IS_ERR(codec->control_data))
-		return PTR_ERR(codec->control_data);
-
-	return 0;
+	return PTR_RET(codec->control_data);
 }
 EXPORT_SYMBOL_GPL(snd_soc_codec_set_cache_io);
 #else
