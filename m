Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0ITAF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 20:05:57 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:60112 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368Ab0ITAFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 20:05:55 -0400
Date: Mon, 20 Sep 2010 01:58:08 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] (trivial) Fix compiler warning in kernel/modules.c
Message-ID: <20100919235808.GB31892@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building with CONFIG_KALLSYMS=n gives following warning:

/mnt/src/linux-git/kernel/module.c: In function ‘post_relocation’:
/mnt/src/linux-git/kernel/module.c:2534:2: warning: passing argument 2 of ‘add_kallsyms’ discards qualifiers from pointer target type
/mnt/src/linux-git/kernel/module.c:2038:13: note: expected ‘struct load_info *’ but argument is of type ‘const struct load_info *’

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 kernel/module.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

For current git (2.6.36-rc4).


diff --git a/kernel/module.c b/kernel/module.c
index d0b5f8d..452052c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2035,7 +2035,7 @@ static inline void layout_symtab(struct module *mod, struct load_info *info)
 {
 }
 
-static void add_kallsyms(struct module *mod, struct load_info *info)
+static void add_kallsyms(struct module *mod, const struct load_info *info)
 {
 }
 #endif /* CONFIG_KALLSYMS */
-- 
1.7.1

