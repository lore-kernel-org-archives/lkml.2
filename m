Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2BEByt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 20:54:49 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48780 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab2BEByq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 20:54:46 -0500
From: Wanlong Gao <wanlong.gao@gmail.com>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: eparis@parisplace.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] selinux: init target class when add avc callback
Date: Sun,  5 Feb 2012 09:53:28 +0800
Message-Id: <1328406808-11309-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Target security class should be initialized when add avc callback.
Although tclass is userless in callbacks now, but it may be used
in the future .

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 security/selinux/avc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index dca1c22..27495e6 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -576,6 +576,7 @@ int avc_add_callback(int (*callback)(u32 event, u32 ssid, u32 tsid,
 	c->events = events;
 	c->ssid = ssid;
 	c->tsid = tsid;
+	c->tclass = tclass;
 	c->perms = perms;
 	c->next = avc_callbacks;
 	avc_callbacks = c;
-- 
1.7.9

