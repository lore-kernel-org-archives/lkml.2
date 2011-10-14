Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1JNQAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:00:34 -0400
Received: from s15407518.onlinehome-server.info ([82.165.136.167]:33770 "EHLO
	s15407518.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583Ab1JNQAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:00:33 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH RESEND] regulator: Fix possible nullpointer dereference in regulator_enable()
Date: Fri, 14 Oct 2011 18:00:29 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-2-686; KDE/4.4.5; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110141800.29440.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case where _regulator_enable returns an error it was not checked
if a supplying regulator exists before trying to disable it, leading
to a null pointer-dereference if no supplying regulator existed.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

---
no changes, except adding the ack from Mark Brown from 2011-09-19
and including the relevant (and forgotten in the first try) LKML

 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 026f3d4..c9dd19c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1425,7 +1425,7 @@ int regulator_enable(struct regulator *regulator)
 	ret = _regulator_enable(rdev);
 	mutex_unlock(&rdev->mutex);
 
-	if (ret != 0)
+	if (ret != 0 && rdev->supply)
 		regulator_disable(rdev->supply);
 
 	return ret;
-- 
1.7.2.3

