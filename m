Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab1I2TxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:53:16 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36368 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab1I2TxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:53:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 9/9] xen/p2m/debugfs: Fix potential pointer exception.
Date: Thu, 29 Sep 2011 15:52:51 -0400
Message-Id: <1317325971-21603-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E84CC9E.00C4:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could be referencing the last + 1 element of level_name[]
array which would cause a pointer exception.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 58efeb9..bc4cf0a 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -786,9 +786,9 @@ EXPORT_SYMBOL_GPL(m2p_find_override_pfn);
 int p2m_dump_show(struct seq_file *m, void *v)
 {
 	static const char * const level_name[] = { "top", "middle",
-						"entry", "abnormal" };
+						"entry", "abnormal", NULL};
 	static const char * const type_name[] = { "identity", "missing",
-						"pfn", "abnormal"};
+						"pfn", "abnormal", NULL};
 #define TYPE_IDENTITY 0
 #define TYPE_MISSING 1
 #define TYPE_PFN 2
-- 
1.7.4.1

