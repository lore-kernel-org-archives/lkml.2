Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935645Ab2JaOF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:05:26 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57243 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935623Ab2JaOFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:05:07 -0400
X-AuditID: b753bd60-95e4fba000002f78-3a-509130116937
Message-ID: <50913011.2030900@hitachi.com>
Date: Wed, 31 Oct 2012 23:05:05 +0900
From: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 2/2 v2] kexec: Export PG_hwpoison flag into vmcoreinfo
References: <508FDEF3.8030601@hitachi.com> <20121030143750.GF2290@redhat.com>
In-Reply-To: <20121030143750.GF2290@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports a PG_hwpoison into vmcoreinfo when
CONFIG_MEMORY_FAILURE is defined.
"makedumpfile" needs to read information of memory, such as
'mem_section', 'zone', 'pageflags' from vmcore.

We introduce a function into "makedumpfile" to exclude
hwpoison page from vmcore dump.
In order to introduce this function, PG_hwpoison flag have
to export into vmcoreinfo.

Signed-off-by: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
---
 kernel/kexec.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 0668d58..0d5d6bc 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1513,6 +1513,9 @@ static int __init crash_save_vmcoreinfo_init(void)
        VMCOREINFO_NUMBER(PG_lru);
        VMCOREINFO_NUMBER(PG_private);
        VMCOREINFO_NUMBER(PG_swapcache);
+#ifdef CONFIG_MEMORY_FAILURE
+       VMCOREINFO_NUMBER(PG_hwpoison);
+#endif

        arch_crash_save_vmcoreinfo();
        update_vmcoreinfo_note();
--
1.7.10.1
