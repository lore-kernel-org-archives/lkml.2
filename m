Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab0DFVij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:38:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:58514 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab0DFVid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:38:33 -0400
Message-ID: <4BBBAA7D.8070006@kernel.org>
Date: Wed, 07 Apr 2010 06:41:17 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH #slabh] nodemask: include slab.h from drivers/base/node.c
References: <4BB95DEE.3050607@kernel.org> <20100406092523.GA30270@elte.hu> <4BBB0118.307@kernel.org> <20100406095012.GA23593@elte.hu>
In-Reply-To: <20100406095012.GA23593@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Apr 2010 21:37:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NODEMASK_ALLOC/FREE are mapped to kmalloc/free if NODES_SHIFT > 8.
Among its several users, drivers/base/node.c wasn't including slab.h
leading to build failure if NODES_SHIFT > 8.  Include slab.h from
drivers/base/node.c.

This isn't an ideal solution but including slab.h directly from
nodemask.h is not an option because nodemask.h gets included
everywhere.  For now, make it work by including slab.h from its users.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/base/node.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 985abd7..057979a 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -15,7 +15,7 @@
 #include <linux/cpu.h>
 #include <linux/device.h>
 #include <linux/swap.h>
-#include <linux/gfp.h>
+#include <linux/slab.h>

 static struct sysdev_class_attribute *node_state_attrs[];

-- 
1.6.4.2

