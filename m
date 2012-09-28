Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946344Ab2I1VjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:39:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62202 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423353Ab2I1VgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:36:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Jingoo Han <jg1.han@samsung.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 04/12] video: exynos: warnings in exynos_dp_core.c
Date: Fri, 28 Sep 2012 23:36:09 +0200
Message-Id: <1348868177-21205-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1348868177-21205-1-git-send-email-arnd@arndb.de>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:MT4x+27R6KkRRROhu3FFpGKrgwf3rtalsumOCvB0XZs
 aswBExNttxnA1Hcr+oV1jNSbsAne8zhYIOO/om4ICbe+Iir8bS
 LrFgUVP9bbx3QcvVsth2UXgpmTorNT3LJicBgMHiOrgkhN5BnW
 oOBukqKPFZUT+2SsByjKVY4LbwxViewyuCQ3R8qetjrLScPz9I
 NFD0zmqxkImK8kwbrKjyd2S8T0sRm+hiwhGwi1Bo/isXeyryWJ
 7IRL7dPVQUxKuyFEbD3JcZ9wVaETOX3WoaxhmvfQwWwMicHOkA
 WmlfAugDCSt+VAsSgzeLi9bzWEy7ASY+Lqa14nB8ELqNvPvvGd
 azM5L5S2uE70qvBkD3t4XUTeRd2uTfy5TARQuSy1KSZ5eVQ3qa
 3otOPIVeNvXOg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something is wrong with the exynos_dp_core logic, and gcc
emits a warning about this. An array is declared in
exynos_dp_process_equalizer_training with length '2',
and exynos_dp_channel_eq_ok tries to access the third
element of it.

This patch is certainly not correct, but hopefully helps
highlight the actual problem. The problem apparently was
introduced by d5c0eed01 "video: exynos_dp: adjust voltage
swing and pre-emphasis during Link Training".

This is what we get in exynos_defconfig:
drivers/video/exynos/exynos_dp_core.c: In function 'exynos_dp_process_equalizer_training':
drivers/video/exynos/exynos_dp_core.c:341:13: warning: array subscript is above array bounds [-Warray-bounds]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/exynos/exynos_dp_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
index cdc1398..358b595 100644
--- a/drivers/video/exynos/exynos_dp_core.c
+++ b/drivers/video/exynos/exynos_dp_core.c
@@ -542,7 +542,7 @@ reduce_link_rate:
 
 static int exynos_dp_process_equalizer_training(struct exynos_dp_device *dp)
 {
-	u8 link_status[2];
+	u8 link_status[3];
 	u8 link_align[3];
 	int lane;
 	int lane_count;
-- 
1.7.10

