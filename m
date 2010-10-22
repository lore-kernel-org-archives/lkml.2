Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab0JVS4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:56:21 -0400
Received: from kroah.org ([198.145.64.141]:34053 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759296Ab0JVS4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:14 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:30 2010
Message-Id: <20101022185230.222613907@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Doug Thompson <dougthompson@xmission.com>
Subject: [032/103] i7core_edac: fix panic in udimm sysfs attributes registration
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcin Slusarz <marcin.slusarz@gmail.com>

commit 64aab720bdf8771214a7c88872bd8e3194c2d279 upstream.

Array of udimm sysfs attributes was not ended with NULL marker, leading to
dereference of random memory.

  EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes() file udimm0
  EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes() file udimm1
  EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes() file udimm2
  BUG: unable to handle kernel NULL pointer dereference at 00000000000001a4
  IP: [<ffffffff81330b36>] edac_create_mci_instance_attributes+0x148/0x1f1
  Pid: 1, comm: swapper Not tainted 2.6.36-rc3-nv+ #483 P6T SE/System Product Name
  RIP: 0010:[<ffffffff81330b36>]  [<ffffffff81330b36>] edac_create_mci_instance_attributes+0x148/0x1f1
  (...)
  Call Trace:
   [<ffffffff81330b86>] edac_create_mci_instance_attributes+0x198/0x1f1
   [<ffffffff81330c9a>] edac_create_sysfs_mci_device+0xbb/0x2b2
   [<ffffffff8132f533>] edac_mc_add_mc+0x46b/0x557
   [<ffffffff81428901>] i7core_probe+0xccf/0xec0
  RIP  [<ffffffff81330b36>] edac_create_mci_instance_attributes+0x148/0x1f1
  ---[ end trace 20de320855b81d78 ]---
  Kernel panic - not syncing: Attempted to kill init!

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/edac/i7core_edac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1140,6 +1140,7 @@ static struct mcidev_sysfs_attribute i7c
 	ATTR_COUNTER(0),
 	ATTR_COUNTER(1),
 	ATTR_COUNTER(2),
+	{ .attr = { .name = NULL } }
 };
 
 static struct mcidev_sysfs_group i7core_udimm_counters = {


