Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab2HNRyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 13:54:32 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55427 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899Ab2HNRxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 13:53:13 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 24/31] arm64: Add support for /proc/sys/debug/exception-trace
Date: Tue, 14 Aug 2012 18:52:25 +0100
Message-Id: <1344966752-16102-25-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 14 Aug 2012 17:54:55.0307 (UTC) FILETIME=[E989D9B0:01CD7A45]
X-MC-Unique: 112081418531203601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q7EHwb07017355

This patch allows setting of the show_unhandled_signals variable via
/proc/sys/debug/exception-trace. The default value is currently 1
showing unhandled user faults (undefined instructions, data aborts) and
invalid signal stack frames.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 kernel/sysctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 87174ef..79dcb00 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1544,7 +1544,7 @@ static struct ctl_table fs_table[] = {
 
 static struct ctl_table debug_table[] = {
 #if defined(CONFIG_X86) || defined(CONFIG_PPC) || defined(CONFIG_SPARC) || \
-    defined(CONFIG_S390) || defined(CONFIG_TILE)
+    defined(CONFIG_S390) || defined(CONFIG_TILE) || defined(CONFIG_ARM64)
 	{
 		.procname	= "exception-trace",
 		.data		= &show_unhandled_signals,

