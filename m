Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab0EQO6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:58:05 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:42879 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595Ab0EQO6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:58:03 -0400
Date: Mon, 17 May 2010 16:57:58 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, Emese Revfy <re.emese@gmail.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH] Typo in drivers/base/core.c
Message-ID: <20100517145757.GA3686@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

	There's a typo in linux' source (CONFIG_MODULE -- missing the
final S) making the whole codeblock unselectable. The included patch
should address this issue.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

----
>From d5fe80140757fedfe19c293cd7af4c1030b92353 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@cs.fau.de>
Date: Mon, 17 May 2010 16:48:59 +0200
Subject: [PATCH] CONFIG_MODULES misstyped as _MODULE

In this code section the final S of CONFIG_MODULES was missed making
the whole check useless

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/base/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index b56a0ba..f801c36 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1372,7 +1372,7 @@ struct device *__root_device_register(const char *name, struct module *owner)
 		return ERR_PTR(err);
 	}
 
-#ifdef CONFIG_MODULE	/* gotta find a "cleaner" way to do this */
+#ifdef CONFIG_MODULES	/* gotta find a "cleaner" way to do this */
 	if (owner) {
 		struct module_kobject *mk = &owner->mkobj;
 
-- 
1.6.3.3












