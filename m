Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0IFOiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:38:24 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33576 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754004Ab0IFOgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:36:32 -0400
Date: Mon, 6 Sep 2010 16:36:30 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: "Juergen E. Fischer" <fischer@norbit.de>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 07/14] drivers/scsi: Removing undead ifdef __ISAPNP__
Message-ID: <1dc9bb1263c30b452523faea097f016c9706d3ab.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __ISAPNP__ ifdef isn't necessary at this point, because it is
checked in an outer ifdef level already and has no effect here.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/scsi/aha152x.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 8eab858..08f59da 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3806,9 +3806,7 @@ static int __init aha152x_init(void)
 #if defined(AHA152X_DEBUG)
 			setup[setup_count].debug       = DEBUG_DEFAULT;
 #endif
-#if defined(__ISAPNP__)
 			pnpdev[setup_count]            = dev;
-#endif
 			printk (KERN_INFO
 				"aha152x: found ISAPnP adapter at io=0x%03x, irq=%d\n",
 				setup[setup_count].io_port, setup[setup_count].irq);
-- 
1.7.0.4

