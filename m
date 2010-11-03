Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab0KCBax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 21:30:53 -0400
Received: from smtp-out.google.com ([74.125.121.35]:35767 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab0KCBal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 21:30:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=p2WmXkmz9JJiwgRT1NtPVgMBo5GUYYctcoDtb+bNnu4cEDabLZlGoS8pU2o8ypzbZ
	yihc6DbfsG7yswPOq0b4A==
Subject: [PATCH v1 10/12] kmsg_dump: Export symbol kmsg_dump() to GPL modules
To: simon.kagstrom@netinsight.net, davem@davemloft.net
From: Mike Waychison <mikew@google.com>
Cc: adurbin@google.com, akpm@linux-foundation.org, chavey@google.com,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Date: Tue, 02 Nov 2010 18:30:25 -0700
Message-ID: <20101103013024.4641.84452.stgit@crlf.mtv.corp.google.com>
In-Reply-To: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The netoops driver would like to call this function to initiate software
induced kernel dumps.

Signed-off-by: Mike Waychison <mikew@google.com>
---

This patch can go away if we have a good way to induce a 'soft' kmsg_dump in
the core kernel.
---
 kernel/printk.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index ad0c74e..2aa0a28 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1572,4 +1572,5 @@ void kmsg_dump(enum kmsg_dump_reason reason, struct pt_regs *pt_regs)
 		dumper->dump(dumper, reason, pt_regs, s1, l1, s2, l2);
 	spin_unlock_irqrestore(&dump_list_lock, flags);
 }
+EXPORT_SYMBOL_GPL(kmsg_dump);
 #endif

