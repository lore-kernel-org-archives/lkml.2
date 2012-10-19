Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161047Ab2JSDEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:04:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:52030 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964823Ab2JSCsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>
Subject: [ 21/76] iscsi-target: Bump defaults for nopin_timeout + nopin_response_timeout values
Date: Thu, 18 Oct 2012 19:46:45 -0700
Message-Id: <20121019024353.514267178@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Andy Grover <agrover@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_core.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


