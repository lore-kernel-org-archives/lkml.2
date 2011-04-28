Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab1D1Rxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 13:53:53 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63505 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab1D1Rxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 13:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ksplice.com; s=google;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=GH8ZRDFxH7U5C8XFun2FTLYjFAGH1UQmui1TSDzC9P+VJvJsXPFa5/0/X17ER+qge3
         SQO22WrW9opbJ0ftvFfU6kGrupv6fdFU0JrfQVsVOj51VOtzz7IAaLy/bVrFlejeDGh9
         8sYYdJ+sp8ZehPiVuZ455b+284ecVNtG5A354=
Date: Thu, 28 Apr 2011 13:53:43 -0400 (EDT)
From: Anders Kaseorg <andersk@ksplice.com>
X-X-Sender: andersk@dr-wily.mit.edu
To: Steven Rostedt <srostedt@redhat.com>
cc: Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] jump label: Fix jump_label_text_reserved
Message-ID: <alpine.DEB.2.02.1104281346060.14343@dr-wily.mit.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typo prevented jump_label_text_reserved from checking for any
conflicts in the core kernel.

Signed-off-by: Anders Kaseorg <andersk@ksplice.com>
---
 kernel/jump_label.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 3b79bd9..4aedde1 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -250,7 +250,7 @@ int jump_label_text_reserved(void *start, void *end)
 {
 	struct jump_entry *iter;
 	struct jump_entry *iter_start = __start___jump_table;
-	struct jump_entry *iter_stop = __start___jump_table;
+	struct jump_entry *iter_stop = __stop___jump_table;
 	int conflict = 0;
 
 	iter = iter_start;
-- 
1.7.5

