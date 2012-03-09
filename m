Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419Ab2CIUSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:18:35 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44901 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759256Ab2CIUSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:18:33 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH] pinctrl: Include <linux/bug.h> to prevent compile errors
Date: Fri,  9 Mar 2012 13:18:25 -0700
Message-Id: <1331324305-1649-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macros in <linux/pinctrl/machine.h> call ARRAY_SIZE(), the definition of
which eventually calls BUILD_BUG_ON_ZERO(), which is defined in
<linux/bug.h>. Include that so that every .c file using the pinctrl macros
doesn't have to do that itself.

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
 include/linux/pinctrl/machine.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index fee4349..012731a 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -12,7 +12,9 @@
 #ifndef __LINUX_PINCTRL_MACHINE_H
 #define __LINUX_PINCTRL_MACHINE_H
 
-#include "pinctrl-state.h"
+#include <linux/bug.h>
+
+#include "pinctrl.h"
 
 enum pinctrl_map_type {
 	PIN_MAP_TYPE_INVALID,
-- 
1.7.0.4

