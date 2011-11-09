Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab1KIAQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 19:16:56 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:49933 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab1KIAQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 19:16:55 -0500
Subject: [PATCH] [TRIVIAL] drm: drop select of SLOW_WORK
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 01:16:50 +0100
Message-ID: <1320797810.14409.419.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slow-work got killed in commit 181a51f6e0. This means that since v2.6.36
there is no Kconfig symbol SLOW_WORK. Apparently selecting that symbol
is a nop. Drop that select.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
DRM isn't an obscure Kconfig symbol. It's hard not to see "select
SLOW_WORK" as a nop. Thus: untested.

 drivers/gpu/drm/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 785127c..866095c 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -9,7 +9,6 @@ menuconfig DRM
 	depends on (AGP || AGP=n) && !EMULATED_CMPXCHG && MMU
 	select I2C
 	select I2C_ALGOBIT
-	select SLOW_WORK
 	help
 	  Kernel-level support for the Direct Rendering Infrastructure (DRI)
 	  introduced in XFree86 4.0. If you say Y here, you need to select
-- 
1.7.4.4

