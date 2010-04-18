Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab0DRQh2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 12:37:28 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:45642 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab0DRQh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 12:37:27 -0400
Message-ID: <4BCB353A.3040806@web.de>
Date: Sun, 18 Apr 2010 18:37:14 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net, Tejun Heo <tj@kernel.org>,
       Tiger Yang <tiger.yang@oracle.com>
Subject: [PATCH] uml: Fix build breakage after slab.h changes
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19A4qxDacVS1dNNFw1ngPtF2Rm2Hn86cM3Sr/by
	uLn/e07Hj3RgkGXS+0zSVtVvpfVQqDFKmEU/cvotB8dmwunpLm
	7DP6VdZ9M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now have to to include linux/slab.h explicitly for kmalloc & friends.
Files that build against host headers already get their prototypes via
um_malloc.h, linux/slab.h may even be unavailable.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 arch/um/drivers/line.c    |    1 +
 arch/um/os-Linux/helper.c |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 64cda95..7a656bd 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -6,6 +6,7 @@
 #include "linux/irqreturn.h"
 #include "linux/kd.h"
 #include "linux/sched.h"
+#include "linux/slab.h"
 #include "chan_kern.h"
 #include "irq_kern.h"
 #include "irq_user.h"
diff --git a/arch/um/os-Linux/helper.c b/arch/um/os-Linux/helper.c
index 06d6ccf..b6b1096 100644
--- a/arch/um/os-Linux/helper.c
+++ b/arch/um/os-Linux/helper.c
@@ -8,7 +8,6 @@
 #include <errno.h>
 #include <sched.h>
 #include <linux/limits.h>
-#include <linux/slab.h>
 #include <sys/socket.h>
 #include <sys/wait.h>
 #include "kern_constants.h"

