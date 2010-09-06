Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0IFOhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:37:12 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33610 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754165Ab0IFOgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:36:49 -0400
Date: Mon, 6 Sep 2010 16:36:47 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Krzysztof Helt <krzysztof.h1@wp.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 10/14] drivers/video: Removing undead ifdef ATAFB_FALCON
Message-ID: <c073783271e15767124fd95ec3c1cd4dcc9004e9.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ATAFB_FALCON ifdef isn't necessary at this point, because it is
checked in an outer ifdef level already and has no effect here.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/video/atafb.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/atafb.c b/drivers/video/atafb.c
index f3aada2..5b2b5ef 100644
--- a/drivers/video/atafb.c
+++ b/drivers/video/atafb.c
@@ -1718,11 +1718,9 @@ static int falcon_setcolreg(unsigned int regno, unsigned int red,
 			(((red & 0xe000) >> 13) | ((red & 0x1000) >> 12) << 8) |
 			(((green & 0xe000) >> 13) | ((green & 0x1000) >> 12) << 4) |
 			((blue & 0xe000) >> 13) | ((blue & 0x1000) >> 12);
-#ifdef ATAFB_FALCON
 		((u32 *)info->pseudo_palette)[regno] = ((red & 0xf800) |
 						       ((green & 0xfc00) >> 5) |
 						       ((blue & 0xf800) >> 11));
-#endif
 	}
 	return 0;
 }
-- 
1.7.0.4

