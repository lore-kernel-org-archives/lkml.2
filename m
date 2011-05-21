Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab1EURs4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 13:48:56 -0400
Received: from mail.perches.com ([173.55.12.10]:1828 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552Ab1EURsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 13:48:45 -0400
From: Joe Perches <joe@perches.com>
To: Ben Greear <greearb@candelatech.com>, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org
Subject: [PATCH 2/2] net: filter: Use WARN_RATELIMIT
Date: Sat, 21 May 2011 10:48:40 -0700
Message-Id: <efa062542c692c3f7743bf2d97b5987ab989e27e.1305999731.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <1305666832.1722.62.camel@Joe-Laptop>
References: <1305666832.1722.62.camel@Joe-Laptop>
In-Reply-To: <cover.1305999731.git.joe@perches.com>
References: <cover.1305999731.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A mis-configured filter can spam the logs with lots of stack traces.

Rate-limit the warnings and add printout of the bogus filter information.

Original-patch-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 net/core/filter.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 0eb8c44..0e3622f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -350,7 +350,9 @@ load_b:
 			continue;
 		}
 		default:
-			WARN_ON(1);
+			WARN_RATELIMIT(1, "Unknown code:%u jt:%u tf:%u k:%u\n",
+				       fentry->code, fentry->jt,
+				       fentry->jf, fentry->k);
 			return 0;
 		}
 	}
-- 
1.7.5.rc3.dirty

