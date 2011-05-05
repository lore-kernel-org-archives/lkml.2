Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab1EETBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:01:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37524 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab1EETBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 15:01:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        xen-devel@lists.xensource.com
Cc: daniel.stodden@citrix.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@citrix.com, Marek Marczykowski <marmarek@mimuw.edu.pl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/3] xen-blkfront: fix data size for xenbus_gather in blkfront_connect
Date: Thu,  5 May 2011 14:55:19 -0400
Message-Id: <1304621721-22608-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304621721-22608-1-git-send-email-konrad.wilk@oracle.com>
References: <1304621721-22608-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090205.4DC2F2A7.007D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Marczykowski <marmarek@mimuw.edu.pl>

barrier variable is int, not long. This overflow caused another variable
override: "err" (in PV code) and "binfo" (in xenlinux code -
drivers/xen/blkfront/blkfront.c). The later caused incorrect device
flags (RO/removable etc).

Signed-off-by: Marek Marczykowski <marmarek@mimuw.edu.pl>
Acked-by: Ian Campbell <Ian.Campbell@citrix.com>
[v1: Changed title]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkfront.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 9cb8668..2075981 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1141,7 +1141,7 @@ static void blkfront_connect(struct blkfront_info *info)
 	}
 
 	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
-			    "feature-barrier", "%lu", &barrier,
+			    "feature-barrier", "%d", &barrier,
 			    NULL);
 
 	/*
-- 
1.7.4.1

