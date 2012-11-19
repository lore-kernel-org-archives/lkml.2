Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2KSFbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:31:13 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42261 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2KSFbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:31:09 -0500
X-Originating-IP: 217.70.178.150
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>, Ram Pai <linuxram@us.ibm.com>,
        T Makphaibulchoke <tmac@hp.com>, Wei Yang <weiyang@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 33/58] kernel/resource.c: Make internal function reallocate_resource static
Date: Sun, 18 Nov 2012 21:28:12 -0800
Message-Id: <1353302917-13995-34-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of kernel/resource.c references reallocate_resource, so
mark it static.  This eliminates warnings from GCC
(-Wmissing-prototypes) and Sparse (-Wdecl).

kernel/resource.c:476:5: warning: no previous prototype for ‘reallocate_resource’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index f593f18..0cc07d4 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -473,7 +473,7 @@ static int find_resource(struct resource *root, struct resource *new,
  * @newsize: new size of the resource descriptor
  * @constraint: the size and alignment constraints to be met.
  */
-int reallocate_resource(struct resource *root, struct resource *old,
+static int reallocate_resource(struct resource *root, struct resource *old,
 			resource_size_t newsize,
 			struct resource_constraint  *constraint)
 {
-- 
1.7.10.4

