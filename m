Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab1AJEpQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 23:45:16 -0500
Received: from mx5.orcon.net.nz ([219.88.242.55]:43785 "EHLO mx5.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab1AJEpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 23:45:14 -0500
From: Michael Cree <mcree@orcon.net.nz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michael Cree <mcree@orcon.net.nz>, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org, Matt Turner <mattst88@gmail.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Bob Tracy <rct@gherkin.frus.com>, Pekka Enberg <penberg@kernel.org>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [PATCH] i2c-i801: Add missing <linux/slab.h> include.
Date: Mon, 10 Jan 2011 17:44:35 +1300
Message-Id: <1294634675-29557-1-git-send-email-mcree@orcon.net.nz>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110104141151.b6035bf3.randy.dunlap@oracle.com>
References: <20110104141151.b6035bf3.randy.dunlap@oracle.com>
X-DSPAM-Check: by mx5.orcon.net.nz on Mon, 10 Jan 2011 17:45:11 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Jan 10 17:45:12 2011
X-DSPAM-Confidence: 0.6201
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Causes compile error on Alpha, but not on x86 because its version
of <asm/pci.h> includes <linux/slab.h>.  In any case, it's a bug
in the driver.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
---

Since no one else has submitted the patch here it goes.  Shall I send it
directly to Linus (since I plan to send some Alpha specific patches very
soon) or will the subsytem maintainers pick it up?

 drivers/i2c/busses/i2c-i801.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 02835ce..7979aef 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -72,6 +72,7 @@
 #include <linux/acpi.h>
 #include <linux/io.h>
 #include <linux/dmi.h>
+#include <linux/slab.h>
 
 /* I801 SMBus address offsets */
 #define SMBHSTSTS(p)	(0 + (p)->smba)
-- 
1.7.2.3

