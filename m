Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2GAVUL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 17:20:11 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1791 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640Ab2GAVUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 17:20:10 -0400
Message-ID: <1341177605.1911.127.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] b43: Kconfig: drop unknown symbol
 'BRCMSMAC_MODULE'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 01 Jul 2012 23:20:05 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 01 Jul 2012 21:20:05.0416 (UTC) FILETIME=[48C26A80:01CD57CF]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no Kconfig symbol BRCMSMAC_MODULE, so the check for it will
always fail. There's no need to append _MODULE to tristate symbols
anyhow, because the config tools will do the right thing automagically.

(While we're touching this Kconfig file replace a tab between "default"
and "y" with a space.)

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Added in commit 4f3d09de38d234ce7ffba5ec5a7e6704f983d375 ("b43: add
option to avoid duplicating device support with brcmsmacb").

1) See commit 282e5aaba2a0cdfde4d2c2e34bc7438cd6f7a00f ("x86: Kconfig:
drop unknown symbol 'APM_MODULE'") for a similar commit.

 drivers/net/wireless/b43/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 3876c7e..7a28d21 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -34,8 +34,8 @@ config B43_BCMA
 config B43_BCMA_EXTRA
 	bool "Hardware support that overlaps with the brcmsmac driver"
 	depends on B43_BCMA
-	default n if BRCMSMAC || BRCMSMAC_MODULE
-	default	y
+	default n if BRCMSMAC
+	default y
 
 config B43_SSB
 	bool
-- 
1.7.7.6

