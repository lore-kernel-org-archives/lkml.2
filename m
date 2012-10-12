Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab2JLAEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 20:04:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46696 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab2JLAED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 20:04:03 -0400
From: "Sanagi, Koki" <sanagi.koki@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: [PATCH] kvm/ftrace: change the diplaying format of vector in
 trace_msi_set_irq
Thread-Topic: [PATCH] kvm/ftrace: change the diplaying format of vector in
 trace_msi_set_irq
Thread-Index: Ac2oDK2na+u3bjRrSGGMeIKuvWCjsQ==
Date: Fri, 12 Oct 2012 00:03:58 +0000
Message-ID: <F6CB40852BC6EF489E0AA83EFF537F4708724889@G01JPEXMBYT04>
Accept-Language: en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-securitypolicycheck: OK by SHieldMailChecker v1.8.4
x-originating-ip: [10.124.101.77]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9C04CYU013491

This patch changes the way to diplay the vector in trace_msi_set_irq from %x to
%u.  Currently, it mismatches another output of ftrace such as kvm_msi_set_irq
and kvm_inj_virq which uses %u.

Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
---
 include/trace/events/kvm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 7ef9e75..0a83632 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -109,7 +109,7 @@ TRACE_EVENT(kvm_msi_set_irq,
 		__entry->data		= data;
 	),
 
-	TP_printk("dst %u vec %x (%s|%s|%s%s)",
+	TP_printk("dst %u vec %u (%s|%s|%s%s)",
 		  (u8)(__entry->address >> 12), (u8)__entry->data,
 		  __print_symbolic((__entry->data >> 8 & 0x7), kvm_deliver_mode),
 		  (__entry->address & (1<<2)) ? "logical" : "physical",
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
