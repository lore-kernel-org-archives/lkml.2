Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab1HYQHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:07:32 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34093 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1HYQHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:07:31 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: timur@freescale.com, linux-kernel@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH] xics/icp_natives: add __init to marker icp_native_init()
Date: Thu, 25 Aug 2011 12:07:13 -0400
Message-Id: <1314288433-26322-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should fix the following warning:

 LD      arch/powerpc/sysdev/xics/built-in.o
WARNING: arch/powerpc/sysdev/xics/built-in.o(.text+0x1310): Section mismatch in
reference from the function .icp_native_init() to the function
.init.text:.icp_native_init_one_node()
The function .icp_native_init() references
the function __init .icp_native_init_one_node().
This is often because .icp_native_init lacks a __init
annotation or the annotation of .icp_native_init_one_node is wrong.

icp_native_init() is only referenced in `arch/powerpc/sysdev/xics/xics-common.c'
by xics_init() which is itself marked with __init.

= not built-tested =

Reported-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 arch/powerpc/sysdev/xics/icp-native.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/xics/icp-native.c b/arch/powerpc/sysdev/xics/icp-native.c
index 50e32af..4c79b6f 100644
--- a/arch/powerpc/sysdev/xics/icp-native.c
+++ b/arch/powerpc/sysdev/xics/icp-native.c
@@ -276,7 +276,7 @@ static const struct icp_ops icp_native_ops = {
 #endif
 };
 
-int icp_native_init(void)
+int __init icp_native_init(void)
 {
 	struct device_node *np;
 	u32 indx = 0;
-- 
1.7.6.153.g78432

