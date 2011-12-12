Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1LLURx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:17:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35655 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab1LLURW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:17:22 -0500
Message-Id: <20111212201715.057471762@openvz.org>
User-Agent: quilt/0.48-1
Date: Tue, 13 Dec 2011 00:06:43 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 1/3] Kconfig: Introduce CHECKPOINT_RESTORE symbol
References: <20111212200642.836001668@openvz.org>
Content-Disposition: inline; filename=kconfig-add-checkpoint-restore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a sake of checkpoint/restore we need auxilary
features being compiled into the kernel, such as additional
prctl codes, /proc/<pid>/map_files and etc...
but same time these features are not mandatory for a
regular kernel so CHECKPOINT_RESTORE config symbol should
bring a way to disable them all at once if one wish to get
rid of additional functionality.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 init/Kconfig |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6.git/init/Kconfig
===================================================================
--- linux-2.6.git.orig/init/Kconfig
+++ linux-2.6.git/init/Kconfig
@@ -773,6 +773,17 @@ config DEBUG_BLK_CGROUP
 
 endif # CGROUPS
 
+config CHECKPOINT_RESTORE
+	bool "Checkpoint/restore support" if EXPERT
+	default n
+	help
+	  Enables additional kernel features in a sake of checkpoint/restore.
+	  In particular it adds auxiliary prctl codes to setup process text,
+	  data and heap segment sizes, and a few additional /proc filesystem
+	  entries.
+
+	  If unsure, say N here.
+
 menuconfig NAMESPACES
 	bool "Namespaces support" if EXPERT
 	default !EXPERT

