Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303Ab2HJOyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:54:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37122 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759203Ab2HJOx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:53:57 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] trivial: pinctrl core: remove extraneous code lines
Date: Fri, 10 Aug 2012 16:53:49 +0200
Message-Id: <1344610429-12607-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function pinctrl_get_locked, pointer p is returned on error, and also
return on no_error.
So, we just return it with no error test.

It's pretty the same in function pinctrl_lookup_state_locked: state is
returned in every case, so we drop the error test and just return state.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/pinctrl/core.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index fb7f3be..7365d46 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -657,11 +657,7 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev)
 	if (p != NULL)
 		return ERR_PTR(-EBUSY);
 
-	p = create_pinctrl(dev);
-	if (IS_ERR(p))
-		return p;
-
-	return p;
+	return create_pinctrl(dev);
 }
 
 /**
@@ -738,10 +734,8 @@ static struct pinctrl_state *pinctrl_lookup_state_locked(struct pinctrl *p,
 			dev_dbg(p->dev, "using pinctrl dummy state (%s)\n",
 				name);
 			state = create_state(p, name);
-			if (IS_ERR(state))
-				return state;
 		} else {
-			return ERR_PTR(-ENODEV);
+			state = ERR_PTR(-ENODEV);
 		}
 	}
 
-- 
1.7.2.5

