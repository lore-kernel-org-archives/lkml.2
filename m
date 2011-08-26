Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab1H0PDx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 11:03:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875Ab1H0O63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:58:29 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:55 2011
Message-Id: <20110826215055.161248144@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [22/35] xen-blkfront: Drop name and minor adjustments for emulated scsi devices
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Bader <stefan.bader@canonical.com>

commit 196cfe2ae8fcdc03b3c7d627e7dfe8c0ce7229f9 upstream.

These were intended to avoid the namespace clash when representing
emulated IDE and SCSI devices. However that seems to confuse users
more than expected (a disk defined as sda becomes xvde).
So for now go back to the scheme which does no adjustments. This
will break when mixing IDE and SCSI names in the configuration of
guests but should be by now expected.

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/xen-blkfront.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -123,8 +123,8 @@ static DEFINE_SPINLOCK(minor_lock);
 #define BLKIF_MINOR_EXT(dev) ((dev)&(~EXTENDED))
 #define EMULATED_HD_DISK_MINOR_OFFSET (0)
 #define EMULATED_HD_DISK_NAME_OFFSET (EMULATED_HD_DISK_MINOR_OFFSET / 256)
-#define EMULATED_SD_DISK_MINOR_OFFSET (EMULATED_HD_DISK_MINOR_OFFSET + (4 * 16))
-#define EMULATED_SD_DISK_NAME_OFFSET (EMULATED_HD_DISK_NAME_OFFSET + 4)
+#define EMULATED_SD_DISK_MINOR_OFFSET (0)
+#define EMULATED_SD_DISK_NAME_OFFSET (EMULATED_SD_DISK_MINOR_OFFSET / 256)
 
 #define DEV_NAME	"xvd"	/* name in /dev */
 


