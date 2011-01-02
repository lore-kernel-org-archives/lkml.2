Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1ABIDh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:03:37 -0500
Received: from mail.windriver.com ([147.11.1.11]:34707 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab1ABHWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:23 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Carpenter <error27@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 065/260] irda: off by one
Date: Sun,  2 Jan 2011 02:16:01 -0500
Message-Id: <1293952756-15010-66-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:17.0117 (UTC) FILETIME=[A535EED0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

commit cf9b94f88bdbe8a02015fc30d7c232b2d262d4ad upstream.

This is an off by one.  We would go past the end when we NUL terminate
the "value" string at end of the function.  The "value" buffer is
allocated in irlan_client_parse_response() or
irlan_provider_parse_command().

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/irda/irlan/irlan_common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/irda/irlan/irlan_common.c b/net/irda/irlan/irlan_common.c
index a788f9e..6130f9d 100644
--- a/net/irda/irlan/irlan_common.c
+++ b/net/irda/irlan/irlan_common.c
@@ -1102,7 +1102,7 @@ int irlan_extract_param(__u8 *buf, char *name, char *value, __u16 *len)
 	memcpy(&val_len, buf+n, 2); /* To avoid alignment problems */
 	le16_to_cpus(&val_len); n+=2;
 
-	if (val_len > 1016) {
+	if (val_len >= 1016) {
 		IRDA_DEBUG(2, "%s(), parameter length to long\n", __func__ );
 		return -RSP_INVALID_COMMAND_FORMAT;
 	}
-- 
1.7.3.3

