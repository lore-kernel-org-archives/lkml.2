Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab0HDRQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 13:16:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58590 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab0HDRQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 13:16:41 -0400
Date: Wed, 4 Aug 2010 10:16:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org
Subject: [PATCH -next] ceph: rbd depends on BLOCK
Message-Id: <20100804101624.5189893c.randy.dunlap@oracle.com>
In-Reply-To: <20100804151035.14678528.sfr@canb.auug.org.au>
References: <20100804151035.14678528.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0209.4C59A06F.001A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_BLOCK is not enabled, fs/ceph/rbd has:
file: fs/ceph/rbd.c: errors: 71, warnings: 18

This is due to BLOCK being spelled as CONFIG_BLOCK
(and depends on being spelled as select).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/ceph/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100804.orig/fs/ceph/Kconfig
+++ linux-next-20100804/fs/ceph/Kconfig
@@ -28,7 +28,7 @@ config CEPH_FS_PRETTYDEBUG
 config CEPH_RBD
 	bool "Rados block device (RBD)"
 	depends on CEPH_FS
-	select  CONFIG_BLOCK
+	depends on BLOCK
 	default y
 	help
 	  If you say Y here, ceph will include rbd, the RADOS block

