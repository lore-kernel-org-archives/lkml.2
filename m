Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab1FNQBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 12:01:41 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:53832 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1FNQBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 12:01:40 -0400
Message-Id: <201106141601.p5EG1dWa010163@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 14 Jun 2011 11:55:22 -0400
Subject: [PATCH] compat: include a declaration of compat_sys_sendmmsg()
To: linux-kernel@vger.kernel.org, arnd@arndb.de
X-OriginalArrivalTime: 14 Jun 2011 16:01:39.0665 (UTC) FILETIME=[58A1EC10:01CC2AAC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required for tilegx to be able to use the compat unistd.h
header where compat_sys_sendmmsg is now mentioned.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 include/linux/compat.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index ddcb7db..846bb17 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -467,6 +467,8 @@ asmlinkage long compat_sys_setsockopt(int fd, int level, int optname,
 				      char __user *optval, unsigned int optlen);
 asmlinkage long compat_sys_sendmsg(int fd, struct compat_msghdr __user *msg,
 				   unsigned flags);
+asmlinkage long compat_sys_sendmmsg(int fd, struct compat_mmsghdr __user *mmsg,
+				    unsigned vlen, unsigned int flags);
 asmlinkage long compat_sys_recvmsg(int fd, struct compat_msghdr __user *msg,
 				   unsigned int flags);
 asmlinkage long compat_sys_recv(int fd, void __user *buf, size_t len,
-- 
1.6.5.2

