Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab0JQOl0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 10:41:26 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61194 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120Ab0JQOlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 10:41:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Qnb1Jl8vXwvoOvWOeUliLwyR8HyBadfUWcATHRgFHTi+OX479zl3LhlVyXgyO3eIuC
         COMustObz3jIU8pJ8XqKjknVdzVfuDOp3d4rnqDHF3L3DuxI46lDibbSa+FV1rT2GhBu
         SJf/esjnfItK0PCTPjt1lKbssE4/z/sPegFOY=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Clemens Ladisch <clemens@ladisch.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] char: hpet: fix information leak to userland
Date: Sun, 17 Oct 2010 18:41:16 +0400
Message-Id: <1287326477-7940-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure info is copied to userland with some padding fields unitialized.
It leads to leaking of stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/char/hpet.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index a4eee32..f6722ef 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -581,6 +581,7 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg,
 		break;
 	case HPET_INFO:
 		{
+			memset(info, 0, sizeof(*info));
 			if (devp->hd_ireqfreq)
 				info->hi_ireqfreq =
 					hpet_time_div(hpetp, devp->hd_ireqfreq);
-- 
1.7.0.4

