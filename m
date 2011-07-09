Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1GIV1g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 17:27:36 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13354 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab1GIV1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 17:27:35 -0400
Date: Sat, 9 Jul 2011 23:17:59 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, Chris Zankel <chris@zankel.net>,
        Emlix GmbH <info@emlix.com>, Fabian Godehardt <fg@emlix.com>,
        Oskar Schirmer <os@emlix.com>, Daniel Gloeckner <dg@emlix.com>
Subject: [PATCH 4/7] XTENSA: static should be at beginning of declaration
In-Reply-To: <alpine.LNX.2.00.1107092304160.25516@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1107092316250.25516@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107092304160.25516@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2073762415-1310246279=:25516"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2073762415-1310246279=:25516
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

Make sure that the 'static' keywork is at the beginning of declaration
for arch/xtensa/variants/s6000/include/variant/dmac.h

This gets rid of warnings like
  warning: ¡static¢ is not at beginning of declaration
when building with -Wold-style-declaration (and/or -Wextra which also
enables it).

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/xtensa/variants/s6000/include/variant/dmac.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/variants/s6000/include/variant/dmac.h b/arch/xtensa/variants/s6000/include/variant/dmac.h
index 89ab948..e81735b 100644
--- a/arch/xtensa/variants/s6000/include/variant/dmac.h
+++ b/arch/xtensa/variants/s6000/include/variant/dmac.h
@@ -357,7 +357,7 @@ static inline u32 s6dmac_channel_enabled(u32 dmac, int chan)
 static inline void s6dmac_dp_setup_group(u32 dmac, int port,
 			int nrch, int frrep)
 {
-	const static u8 mask[4] = {0, 3, 1, 2};
+	static const u8 mask[4] = {0, 3, 1, 2};
 	BUG_ON(dmac != S6_REG_DPDMA);
 	if ((port < 0) || (port > 3) || (nrch < 1) || (nrch > 4))
 		return;
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-2073762415-1310246279=:25516--
