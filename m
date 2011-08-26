Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab1H0PDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 11:03:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab1H0O6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:58:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:55 2011
Message-Id: <20110826215055.267771875@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [23/35] xen-blkfront: Fix one off warning about name clash
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Bader <stefan.bader@canonical.com>

commit 89153b5cae9f40c224a5d321665a97bf14220c2c upstream.

Avoid telling users to use xvde and onwards when using xvde.

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/xen-blkfront.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -529,7 +529,7 @@ static int xlvbd_alloc_gendisk(blkif_sec
 		minor = BLKIF_MINOR_EXT(info->vdevice);
 		nr_parts = PARTS_PER_EXT_DISK;
 		offset = minor / nr_parts;
-		if (xen_hvm_domain() && offset <= EMULATED_HD_DISK_NAME_OFFSET + 4)
+		if (xen_hvm_domain() && offset < EMULATED_HD_DISK_NAME_OFFSET + 4)
 			printk(KERN_WARNING "blkfront: vdevice 0x%x might conflict with "
 					"emulated IDE disks,\n\t choose an xvd device name"
 					"from xvde on\n", info->vdevice);


