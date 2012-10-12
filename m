Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2JLGqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 02:46:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26635 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755854Ab2JLGqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 02:46:33 -0400
X-IronPort-AV: E=Sophos;i="4.80,576,1344182400"; 
   d="scan'208";a="5988225"
Message-ID: <5077BC82.6050105@cn.fujitsu.com>
Date: Fri, 12 Oct 2012 14:45:22 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: x86@kernel.org, kexec@lists.infradead.org, linux-doc@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, mtosatti@redhat.com
CC: linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH 3/3] sysctl: introduce a new interface to control kdump-vmcs-clear
 behaviour
References: <5077BB7B.4030203@cn.fujitsu.com>
In-Reply-To: <5077BB7B.4030203@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 14:46:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 14:46:17,
	Serialize complete at 2012/10/12 14:46:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports the variable clear_loaded_vmcs_enabled to userspace.

Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
---
 Documentation/sysctl/kernel.txt |    8 ++++++++
 kernel/sysctl.c                 |   10 ++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 6d78841..038148b 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -25,6 +25,7 @@ show up in /proc/sys/kernel:
 - bootloader_version	     [ X86 only ]
 - callhome		     [ S390 only ]
 - cap_last_cap
+- clear_loaded_vmcs	     [ X86 only ]
 - core_pattern
 - core_pipe_limit
 - core_uses_pid
@@ -164,6 +165,13 @@ CAP_LAST_CAP from the kernel.
 
 ==============================================================
 
+clear_loaded_vmcs
+
+Controls if VMCSs should be cleared when host is doing kdump.  Exports
+clear_loaded_vmcs_enabled from the kernel.
+
+==============================================================
+
 core_pattern:
 
 core_pattern is used to specify a core dumpfile pattern name.
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4ab1187..3ab7d9c 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -63,6 +63,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
+#include <asm/kexec.h>
 
 #ifdef CONFIG_X86
 #include <asm/nmi.h>
@@ -994,6 +995,15 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_KEXEC
+	{
+		.procname	= "clear_loaded_vmcs",
+		.data		= &clear_loaded_vmcs_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
 	{ }
 };
 
-- 
1.7.1
