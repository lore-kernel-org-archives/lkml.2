Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab1J1Dib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 23:38:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35017 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754868Ab1J1Dia convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 23:38:30 -0400
Message-ID: <1319773094.6759.32.camel@deadeye>
Subject: [PATCH 2/2] module: Re-enable dynamic debugging for GPL-compatible
 OOT modules
From: Ben Hutchings <ben@decadent.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Nick Bowler <nbowler@elliptictech.com>, Greg KH <greg@kroah.com>,
        Dave Jones <davej@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Date: Fri, 28 Oct 2011 04:38:14 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamic debugging was enabled for GPL-compatible out-of-tree modules
until my addition of TAINT_OOT_MODULE.  It should continue to be
enabled now.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/module.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index dab585e..448fd77 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2881,7 +2881,7 @@ static struct module *load_module(void __user *umod,
 	}
 
 	/* This has to be done once we're sure module name is unique. */
-	if (!mod->taints || mod->taints == (1U<<TAINT_CRAP))
+	if (!(mod->taints & ~(1U << TAINT_CRAP | 1U << TAINT_OOT_MODULE)))
 		dynamic_debug_setup(info.debug, info.num_debug);
 
 	/* Find duplicate symbols */
@@ -2918,7 +2918,7 @@ static struct module *load_module(void __user *umod,
 	module_bug_cleanup(mod);
 
  ddebug:
-	if (!mod->taints || mod->taints == (1U<<TAINT_CRAP))
+	if (!(mod->taints & ~(1U << TAINT_CRAP | 1U << TAINT_OOT_MODULE)))
 		dynamic_debug_remove(info.debug);
  unlock:
 	mutex_unlock(&module_mutex);
-- 
1.7.7


