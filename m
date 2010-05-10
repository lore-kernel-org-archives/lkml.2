Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186Ab0EJXFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:05:37 -0400
Received: from kroah.org ([198.145.64.141]:45400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932946Ab0EJW6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:34 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:42 2010
Message-Id: <20100510223542.129519380@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [86/98] V4L/DVB: budget: Oops: "BUG: unable to handle kernel NULL pointer dereference"
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 6f550dc08369ee0bc6402963c377e65f0f2e3b71 upstream.

Never call dvb_frontend_detach if we failed to attach a frontend. This fixes
the following oops, which will be triggered by a missing stv090x module:

[    8.172997] DVB: registering new adapter (TT-Budget S2-1600 PCI)
[    8.209018] adapter has MAC addr = 00:d0:5c:cc:a7:29
[    8.328665] Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    8.328753] Intel ICH 0000:00:1f.5: setting latency timer to 64
[    8.562047] DVB: Unable to find symbol stv090x_attach()
[    8.562117] BUG: unable to handle kernel NULL pointer dereference at 000000ac
[    8.562239] IP: [<e08b04a3>] dvb_frontend_detach+0x4/0x67 [dvb_core]

Ref http://bugs.debian.org/575207

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/ttpci/budget.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/media/dvb/ttpci/budget.c
+++ b/drivers/media/dvb/ttpci/budget.c
@@ -643,9 +643,6 @@ static void frontend_init(struct budget
 					&budget->i2c_adap,
 					&tt1600_isl6423_config);
 
-			} else {
-				dvb_frontend_detach(budget->dvb_frontend);
-				budget->dvb_frontend = NULL;
 			}
 		}
 		break;


