Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab2ADCcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 21:32:53 -0500
Received: from ozlabs.org ([203.10.76.45]:47214 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035Ab2ADCcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 21:32:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Maik Broemme <mbroemme@plusserver.de>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] intelfbdrv.c: bailearly is an int module_param
In-Reply-To: <20120103131748.GA11575@elgon.mountain>
References: <20120103131748.GA11575@elgon.mountain>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 04 Jan 2012 12:59:26 +1030
Message-ID: <8739bwdwu1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter points out that it's an int, not a bool:
intelfbdrv.c:818:	if (bailearly == 1)
intelfbdrv.c:828:	if (bailearly == 2)
intelfbdrv.c:836:	if (bailearly == 3)
intelfbdrv.c:842:	if (bailearly == 4)
intelfbdrv.c:851:	if (bailearly == 5)
intelfbdrv.c:859:	if (bailearly == 6)
intelfbdrv.c:866:				    bailearly > 6 ? bailearly - 6 : 0);
intelfbdrv.c:874:	if (bailearly == 18)
intelfbdrv.c:886:	if (bailearly == 19)
intelfbdrv.c:893:	if (bailearly == 20)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/video/intelfb/intelfbdrv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/intelfb/intelfbdrv.c b/drivers/video/intelfb/intelfbdrv.c
--- a/drivers/video/intelfb/intelfbdrv.c
+++ b/drivers/video/intelfb/intelfbdrv.c
@@ -263,7 +263,7 @@ module_param(probeonly, bool, 0);
 MODULE_PARM_DESC(probeonly, "Do a minimal probe (debug)");
 module_param(idonly, bool, 0);
 MODULE_PARM_DESC(idonly, "Just identify without doing anything else (debug)");
-module_param(bailearly, bool, 0);
+module_param(bailearly, int, 0);
 MODULE_PARM_DESC(bailearly, "Bail out early, depending on value (debug)");
 module_param(mode, charp, S_IRUGO);
 MODULE_PARM_DESC(mode,
