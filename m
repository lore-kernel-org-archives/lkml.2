Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab2JTTFY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 15:05:24 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52348 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab2JTTFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 15:05:23 -0400
Date: Sat, 20 Oct 2012 23:05:19 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] lockdep: Use KSYM_NAME_LEN'ed buffer for __get_key_name
Message-ID: <20121020190519.GH25467@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not a big deal, but since other __get_key_name callers
use it lets be consistent.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 kernel/lockdep_proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/kernel/lockdep_proc.c
===================================================================
--- linux-2.6.git.orig/kernel/lockdep_proc.c
+++ linux-2.6.git/kernel/lockdep_proc.c
@@ -39,7 +39,7 @@ static void l_stop(struct seq_file *m, v
 
 static void print_name(struct seq_file *m, struct lock_class *class)
 {
-	char str[128];
+	char str[KSYM_NAME_LEN];
 	const char *name = class->name;
 
 	if (!name) {
