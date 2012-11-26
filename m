Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab2KZRCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:02:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47236 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab2KZRCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:02:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 047/270] iscsi-target: Bump defaults for nopin_timeout + nopin_response_timeout values
Date: Mon, 26 Nov 2012 14:55:37 -0200
Message-Id: <1353949160-26803-48-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit cf0eb28d3ba60098865bf7dbcbfdd6b1cc483e3b upstream.

This patch increases the default for nopin_timeout to 15 seconds (wait
between sending a new NopIN ping) and nopin_response_timeout to 30 seconds
(wait for NopOUT response before failing the connection) in order to avoid
false positives by iSCSI Initiators who are not always able (under load) to
respond to NopIN echo PING requests within the current 5 second window.

False positives have been observed recently using Open-iSCSI code on v3.3.x
with heavy large-block READ workloads over small MTU 1 Gb/sec ports, and
increasing these values to more reasonable defaults significantly reduces
the possibility of false positive NopIN response timeout events under
this specific workload.

Historically these have been set low to initiate connection recovery as
soon as possible if we don't hear a ping back, but for modern v3.x code
on 1 -> 10 Gb/sec ports these new defaults make alot more sense.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Andy Grover <agrover@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/iscsi/iscsi_target_core.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index 1dd5716..8bb81d68 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -25,10 +25,10 @@
 #define NA_DATAOUT_TIMEOUT_RETRIES	5
 #define NA_DATAOUT_TIMEOUT_RETRIES_MAX	15
 #define NA_DATAOUT_TIMEOUT_RETRIES_MIN	1
-#define NA_NOPIN_TIMEOUT		5
+#define NA_NOPIN_TIMEOUT		15
 #define NA_NOPIN_TIMEOUT_MAX		60
 #define NA_NOPIN_TIMEOUT_MIN		3
-#define NA_NOPIN_RESPONSE_TIMEOUT	5
+#define NA_NOPIN_RESPONSE_TIMEOUT	30
 #define NA_NOPIN_RESPONSE_TIMEOUT_MAX	60
 #define NA_NOPIN_RESPONSE_TIMEOUT_MIN	3
 #define NA_RANDOM_DATAIN_PDU_OFFSETS	0
-- 
1.7.9.5

