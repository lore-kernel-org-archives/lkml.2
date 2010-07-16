Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935452Ab0GPCmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 22:42:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51411 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935363Ab0GPCmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 22:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=LTmOeA6zJKXF0U7bj6Kq2fkXqiYCvnT7LKrC7Ma30jAsOl7CSUta/1B+g/bPcmra+u
         m5vi06AxD58s2510HUvYw/lYvztMubyDzpTJ+t1Y3M4NadndW6Sw+w3t3Ch7OMdimkvD
         1YOdEm/tMfDWRS9yI7doPXVGooxBpfeGcBi/Q=
Subject: [PATCH] uda134x: properly free allocated memory if
	uda134x_soc_probe fail with unknown codec type
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        =?ISO-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>, alsa-devel@alsa-project.org
Content-Type: text/plain
Date: Fri, 16 Jul 2010 10:42:46 +0800
Message-Id: <1279248166.10112.9.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If uda134x_soc_probe fail with unknown codec type, it should properly free
allocated memory before return -EINVAL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This case won't be executed in current implementation because there is a
model checking in the begin of uda134x_soc_probe.
But since the code is there, I think it's good to make it correct.
Otherwise, we can simply remove the default case.

 sound/soc/codecs/uda134x.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/uda134x.c b/sound/soc/codecs/uda134x.c
index 28aac53..9bff3c6 100644
--- a/sound/soc/codecs/uda134x.c
+++ b/sound/soc/codecs/uda134x.c
@@ -566,9 +566,10 @@ static int uda134x_soc_probe(struct platform_device *pdev)
 					ARRAY_SIZE(uda1345_snd_controls));
 	break;
 	default:
+		ret = -EINVAL;
 		printk(KERN_ERR "%s unknown codec type: %d",
 			__func__, pd->model);
-	return -EINVAL;
+	break;
 	}
 
 	if (ret < 0) {
-- 
1.5.4.3



