Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1EDPiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:38:18 -0400
Received: from smtp.outflux.net ([198.145.64.163]:58363 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828Ab1EDPiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:38:17 -0400
Date: Wed, 4 May 2011 08:38:07 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] iosched: remove redundant sprintf
Message-ID: <20110504153807.GA30153@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the anticipatory scheduler was dropped, there was no need to
special-case the request_module string. As such, drop the redundant
sprintf and stack variable.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 block/elevator.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 45ca1e3..2a0b653 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -155,13 +155,8 @@ static struct elevator_type *elevator_get(const char *name)
 
 	e = elevator_find(name);
 	if (!e) {
-		char elv[ELV_NAME_MAX + strlen("-iosched")];
-
 		spin_unlock(&elv_list_lock);
-
-		snprintf(elv, sizeof(elv), "%s-iosched", name);
-
-		request_module("%s", elv);
+		request_module("%s-iosched", name);
 		spin_lock(&elv_list_lock);
 		e = elevator_find(name);
 	}
-- 
1.7.4.1

-- 
Kees Cook
Ubuntu Security Team
