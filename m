Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab0FCQCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:02:12 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38650 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843Ab0FCQCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:02:10 -0400
From: Florian Westphal <fw@strlen.de>
To: linux-kernel@vger.kernel.org
Cc: Florian Westphal <fwestphal@astaro.com>, trivial@kernel.org
Subject: [PATCH, RESEND] compat_ioctl: add compat handler for PPPIOCGL2TPSTATS ioctl
Date: Thu,  3 Jun 2010 18:00:14 +0200
Message-Id: <1275580814-19353-1-git-send-email-fw@strlen.de>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Westphal <fwestphal@astaro.com>

fixes following error:
ioctl32(openl2tpd:7480): Unknown cmd fd(14) cmd(80487436){t:'t';sz:72} arg(ffa7e6c0) on socket:[105094]

The structure used in the ioctl uses "aligned_u64" and thus doesn't need
fixups.

Cc: trivial@kernel.org
Signed-off-by: Florian Westphal <fwestphal@astaro.com>
---
noticed that this wasn't applied, most likely due to vger
outage back in April.

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 641640d..d58d4cf 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1100,6 +1100,7 @@ COMPATIBLE_IOCTL(PPPIOCCONNECT)
 COMPATIBLE_IOCTL(PPPIOCDISCONN)
 COMPATIBLE_IOCTL(PPPIOCATTCHAN)
 COMPATIBLE_IOCTL(PPPIOCGCHAN)
+COMPATIBLE_IOCTL(PPPIOCGL2TPSTATS)
 /* PPPOX */
 COMPATIBLE_IOCTL(PPPOEIOCSFWD)
 COMPATIBLE_IOCTL(PPPOEIOCDFWD)
-- 
1.6.4.4

