Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab1LHIud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:50:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57328 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab1LHIub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:50:31 -0500
Message-ID: <4EE07AE6.10804@cn.fujitsu.com>
Date: Thu, 08 Dec 2011 16:52:54 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] kvm_tools: fix build fail
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-08 16:49:50,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-08 16:49:52
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e5fd47bfab2df0c2184cc0bf4245d8e1bb7724fb in -tip tree adds a
"bool set_pm_idle_to_default(void);" to system.h which causes kvm_tool build fail:

In file included from include/kvm/barrier.h:13:0,
                 from virtio/core.c:5:
../../arch/x86/include/asm/system.h:404:6: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘set_pm_idle_to_default’

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/tools/kvm/include/kvm/barrier.h b/tools/kvm/include/kvm/barrier.h
index c11a239..480276f 100644
--- a/tools/kvm/include/kvm/barrier.h
+++ b/tools/kvm/include/kvm/barrier.h
@@ -7,6 +7,7 @@
  * Provide the dependencies here - we can drop these wrappers once
  * the header is fixed upstream:
  */
+#include <stdbool.h>
 #include <linux/stringify.h>
 #include <linux/bitops.h>
 #include <asm/alternative.h>

