Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab1LEVNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:13:48 -0500
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:36535 "EHLO
	homiemail-a60.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932226Ab1LEVNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:13:47 -0500
Subject: [PATCH] resource cgroups: remove bogus cast
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Pavel Emelianov <xemul@openvz.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>
Cc: lkml <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Mon, 05 Dec 2011 22:13:41 +0100
Message-ID: <1323119621.3244.1.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

The memparse() function already accepts const char * as the parsing string.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 kernel/res_counter.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 34683ef..6d269cc 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -159,8 +159,7 @@ int res_counter_memparse_write_strategy(const char *buf,
 		return 0;
 	}
 
-	/* FIXME - make memparse() take const char* args */
-	*res = memparse((char *)buf, &end);
+	*res = memparse(buf, &end);
 	if (*end != '\0')
 		return -EINVAL;
 
-- 
1.7.4.1



