Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab0JRQ1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 12:27:18 -0400
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:56531 "EHLO
	homiemail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755163Ab0JRQ1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 12:27:17 -0400
Subject: [PATCH] scsi-netlink: include missing types header
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 13:25:36 -0300
Message-ID: <1287419136.7945.4.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scsi netlink: include missing types header

This fixes this warning (found on my latest randconfig test):
scsi_netlink.h:108: found __[us]{8,16,32,64} type without #include <linux/types.h>

I know that this header is already included in linux/netlink.h so I wonder why check_header is complaining about it. If ignorable, please disregard.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 include/scsi/scsi_netlink.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/scsi/scsi_netlink.h b/include/scsi/scsi_netlink.h
index 58ce8fe..5cb20cc 100644
--- a/include/scsi/scsi_netlink.h
+++ b/include/scsi/scsi_netlink.h
@@ -23,7 +23,7 @@
 #define SCSI_NETLINK_H
 
 #include <linux/netlink.h>
-
+#include <linux/types.h>
 
 /*
  * This file intended to be included by both kernel and user space
-- 
1.7.0.4



