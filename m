Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab0FVIrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 04:47:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:6500 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab0FVIrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 04:47:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LkFFJcWgTRNf9AvKv6PtoeMjm1dmwpq30HLLL+T+k5w/9XH138yunvy+FERULGveCR
         R1qLGPIG38bmPhgcui/dz2iESvDjwZSqVvl2WBepw8JpwmGLO/UkFXq9TkKMp0USPnI6
         OvNQr5+OzMWj4/l3+JEGxDDf3t+QykuwGNYMA=
From: Sankar P <sankar.curiosity@gmail.com>
To: penberg@cs.helsinki.fi
Cc: lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, lrodriguez@atheros.com,
       catalin.marinas@arm.com, rnagarajan@novell.com, teheo@novell.com,
       linux-mm@kvack.org, paulmck@linux.vnet.ibm.com, mingo@elte.hu,
       akpm@linux-foundation.org, Sankar P <sankar.curiosity@gmail.com>
Subject: [PATCH] kmemleak: config-options: Default buffer size for kmemleak
Date: Tue, 22 Jun 2010 14:16:43 +0530
Message-Id: <1277196403-20836-1-git-send-email-sankar.curiosity@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <4C20702C.1080405@cs.helsinki.fi>
References: <AANLkTimb7rP0rS0OU8nan5uNEhHx_kEYL99ImZ3c8o0D@mail.gmail.com> <1277189909-16376-1-git-send-email-sankar.curiosity@gmail.com> <4C20702C.1080405@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we try to find the memory leaks in kernel that is
compiled with 'make defconfig', the default buffer size
of DEBUG_KMEMLEAK_EARLY_LOG_SIZE seem to be inadequate.

Change the buffer size from 400 to 1000,
which is sufficient for most cases.

Signed-off-by: Sankar P <sankar.curiosity@gmail.com>
---

Thanks to Pekka Enberg's comments on my previous mail, I am sending a better patch,
and adding new reviewers as suggested by the get_maintainer script. 

 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e722e9d..5eb9463 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -382,7 +382,7 @@ config DEBUG_KMEMLEAK_EARLY_LOG_SIZE
 	int "Maximum kmemleak early log entries"
 	depends on DEBUG_KMEMLEAK
 	range 200 40000
-	default 400
+	default 1000
 	help
 	  Kmemleak must track all the memory allocations to avoid
 	  reporting false positives. Since memory may be allocated or
-- 
1.6.4.2

