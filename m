Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0C3SDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:03:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab0C3SDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:03:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FS-Cache: Order the debugfs stats correctly
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-cachefs@redhat.com, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Tue, 30 Mar 2010 19:02:08 +0100
Message-ID: <20100330180208.17173.59826.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Order the debugfs statistics correctly.  The values displayed through a
seq_printf() statement should be in the same order as the names in the format
string.

In the 'Lookups' line, objects created ('crt=') and lookups timed out ('tmo=')
have their values transposed.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/stats.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
index 46435f3..4765190 100644
--- a/fs/fscache/stats.c
+++ b/fs/fscache/stats.c
@@ -165,8 +165,8 @@ static int fscache_stats_show(struct seq_file *m, void *v)
 		   atomic_read(&fscache_n_object_lookups),
 		   atomic_read(&fscache_n_object_lookups_negative),
 		   atomic_read(&fscache_n_object_lookups_positive),
-		   atomic_read(&fscache_n_object_lookups_timed_out),
-		   atomic_read(&fscache_n_object_created));
+		   atomic_read(&fscache_n_object_created),
+		   atomic_read(&fscache_n_object_lookups_timed_out));
 
 	seq_printf(m, "Updates: n=%u nul=%u run=%u\n",
 		   atomic_read(&fscache_n_updates),

