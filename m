Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab0C3GVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:21:01 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34946 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab0C3GUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:20:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IdFfJHGWQreRH9jdPhs7Mzgi1b3PbJe9PPZ6trN63/bUUUcPGkqnrev0yJ9Ku6B02r
         JUoDXClWTRnLALytqmIxQ09z3n59ihWJDZ1tFlaZTlaw4masmrqqaWA1HGXgLQHxSTai
         KU8xwf3foaZhEU5nhau/3rJe7XH0CsH8CMzxw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/6] procfs: Use generic_file_llseek in /proc/kmsg
Date: Tue, 30 Mar 2010 08:20:12 +0200
Message-Id: <1269930015-863-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to hold the bkl to seek here, none of the other
fops callbacks use it.

Use generic_file_llseek explicitly.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Kacur <jkacur@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 fs/proc/kmsg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/proc/kmsg.c b/fs/proc/kmsg.c
index cfe90a4..bd4b5a7 100644
--- a/fs/proc/kmsg.c
+++ b/fs/proc/kmsg.c
@@ -53,6 +53,7 @@ static const struct file_operations proc_kmsg_operations = {
 	.poll		= kmsg_poll,
 	.open		= kmsg_open,
 	.release	= kmsg_release,
+	.llseek		= generic_file_llseek,
 };
 
 static int __init proc_kmsg_init(void)
-- 
1.6.2.3

