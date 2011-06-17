Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791Ab1FQI6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:58:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758578Ab1FQI5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:57:19 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] Allow reading/writing all memory through /dev/mem
Date: Fri, 17 Jun 2011 10:48:27 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc2-0.0.5.bd76874-default; KDE/4.6.0; i686; ; )
References: <201106171038.25988.ptesarik@suse.cz>
In-Reply-To: <201106171038.25988.ptesarik@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171048.27289.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With all pieces in place, I can now change the type of the physical
address pointer and get access to all memory.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 drivers/char/mem.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index cbbaf36..bc16ab7 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -93,7 +93,7 @@ void __weak unxlate_dev_mem_ptr(phys_addr_t phys, void *addr)
 static ssize_t read_mem(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos)
 {
-	unsigned long p = *ppos;
+	phys_addr_t p = *ppos;
 	ssize_t read, sz;
 	char *ptr;
 
@@ -153,7 +153,7 @@ static ssize_t read_mem(struct file *file, char __user *buf,
 static ssize_t write_mem(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
-	unsigned long p = *ppos;
+	phys_addr_t p = *ppos;
 	ssize_t written, sz;
 	unsigned long copied;
 	void *ptr;
-- 
1.7.3.4
