Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291Ab2IRPFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 11:05:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab2IRPFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 11:05:47 -0400
Date: Tue, 18 Sep 2012 11:05:44 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: cl@linux-foundation.org
Subject: Taint kernel when we detect a corrupted slab.
Message-ID: <20120918150543.GA14718@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	cl@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't seem worth adding a new taint flag for this, so just re-use
the one from 'bad page'

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/mm/slub.c b/mm/slub.c
index 2fdd96f..0c5009d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -568,6 +568,8 @@ static void slab_bug(struct kmem_cache *s, char *fmt, ...)
 	printk(KERN_ERR "BUG %s (%s): %s\n", s->name, print_tainted(), buf);
 	printk(KERN_ERR "----------------------------------------"
 			"-------------------------------------\n\n");
+
+	add_taint(TAINT_BAD_PAGE);
 }
 
 static void slab_fix(struct kmem_cache *s, char *fmt, ...)
