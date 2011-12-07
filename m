Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739Ab1LGQXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:23:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933639Ab1LGQXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:23:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:17 2011
Message-Id: <20111207161217.479239582@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:35 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [033/104] regulator: aat2870: Fix the logic of checking if no id is matched in aat2870_get_regulator
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit d4d6373c1109b11c8118340be97ae31b8f94d66a upstream.

In current implementation, the pointer ri is not NULL if no id is matched.
Fix it by checking i == ARRAY_SIZE(aat2870_regulators) if no id is matched.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/regulator/aat2870-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/aat2870-regulator.c
+++ b/drivers/regulator/aat2870-regulator.c
@@ -159,7 +159,7 @@ static struct aat2870_regulator *aat2870
 			break;
 	}
 
-	if (!ri)
+	if (i == ARRAY_SIZE(aat2870_regulators))
 		return NULL;
 
 	ri->enable_addr = AAT2870_LDO_EN;


