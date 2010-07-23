Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab0GWFyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:54:13 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37511 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab0GWFyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=e2WAhzdgCB3RRlUCEgwYJQ7u/l//5CBnc5iioqgkHU/P0uNCGsT2OhIsbxvTgQjGGo
         rKeDdTCIQHTp4MHNoBQ9iu5F16Gvgot100NT6eN2cmMWiXO/P7uRMwtvJ1LEijlL6ooo
         I5aGfXFgHCEJimaQihl0b5DCow5SRQkkKvPIQ=
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Barry Song <21cnbao@gmail.com>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Arthur <linux@wolfsonmicro.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH v2 02/12] ak4642: fix a memory leak if failed to initialise AK4642
Date: Fri, 23 Jul 2010 05:53:44 +0000
Message-Id: <1279864434-8010-3-git-send-email-axel.lin@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
References: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ak4642 should be kfreed if ak4642_init() return error.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Reviewed-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
---
 sound/soc/codecs/ak4642.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index 7528a54..4feefa8 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -491,8 +491,10 @@ static int ak4642_i2c_probe(struct i2c_client *i2c,
 	codec->control_data = i2c;
 
 	ret = ak4642_init(ak4642);
-	if (ret < 0)
+	if (ret < 0) {
 		printk(KERN_ERR "failed to initialise AK4642\n");
+		kfree(ak4642);
+	}
 
 	return ret;
 }
-- 
1.7.0.4

