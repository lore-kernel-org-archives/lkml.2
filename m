Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2LNLFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:05:15 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:46752 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab2LNLCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:02:47 -0500
Subject: [PATCH 04/12] pps: pps_parport: fix oops on module unloading
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Date: Fri, 14 Dec 2012 15:02:40 +0400
Message-ID: <20121214110240.11019.48429.stgit@zurg>
In-Reply-To: <20121214110229.11019.63713.stgit@zurg>
References: <20121214110229.11019.63713.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems like port->cad is NULL for unused ports

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>

---

[    0.151192] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    0.151759] IP: [<ffffffffa2de3048>] parport_detach+0x24/0x95 [pps_parport]
[    0.153875] Process rmmod (pid: 22117, threadinfo ffff880061174000, task ffff8800613db000)
[    0.153875] Call Trace:
[    0.153875]  [<ffffffffa064c49c>] parport_unregister_driver+0x51/0x8b [parport]
[    0.153875]  [<ffffffffa2de364f>] pps_parport_exit+0x17/0x20 [pps_parport]
[    0.153875]  [<ffffffff8110e976>] sys_delete_module+0x328/0x3d2
[    0.153875]  [<ffffffff8168e7e8>] tracesys+0xe1/0xe6
---
 drivers/pps/clients/pps_parport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pps/clients/pps_parport.c b/drivers/pps/clients/pps_parport.c
index e1b4705..7e9bcd4 100644
--- a/drivers/pps/clients/pps_parport.c
+++ b/drivers/pps/clients/pps_parport.c
@@ -194,7 +194,7 @@ static void parport_detach(struct parport *port)
 	struct pps_client_pp *device;
 
 	/* FIXME: oooh, this is ugly! */
-	if (strcmp(pardev->name, KBUILD_MODNAME))
+	if (!pardev || strcmp(pardev->name, KBUILD_MODNAME))
 		/* not our port */
 		return;
 

