Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab0FHIhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 04:37:09 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39935 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab0FHIhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 04:37:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Bwi1jGEXi58239IffvSSsPVuSUIg3stYitSXboWquaB/sJ8bOkdYx3sKwZbRBEfnSd
         HKm3k/nxbiR7sUad+HiB9oRUpNfsNHxJyXyNApyNKSOcfGmuIvyCAgKmeDCS/f3uRrS4
         N9K0DWpqQDBs6ai7lhiFYKBDECqQsVlzpLzww=
MIME-Version: 1.0
Date: Tue, 8 Jun 2010 16:37:04 +0800
Message-ID: <AANLkTik9UM9ta3r7ZNt8Z-CNS6Vz-aIWb_qewgECFfoe@mail.gmail.com>
Subject: [PATCH] Documentation/filesystems/xip.txt: clarify the statement: The 
	block device option is mandatory for execute-in-place
From: shenghui <crosslonelyover@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

      The origin text in xip.txt said:
" The block device operation is optional, these block devices support it as of
  today:
  - dcssblk: s390 dcss block device driver
"

      While in fs/ext2/xip.c, we can get the following code:
  65void ext2_xip_verify_sb(struct super_block *sb)
  66{
  67        struct ext2_sb_info *sbi = EXT2_SB(sb);
  68
  69        if ((sbi->s_mount_opt & EXT2_MOUNT_XIP) &&
  70            !sb->s_bdev->bd_disk->fops->direct_access) {
  71                sbi->s_mount_opt &= (~EXT2_MOUNT_XIP);
  72                ext2_msg(sb, KERN_WARNING,
  73                             "warning: ignoring xip option - "
  74                             "not supported by bdev");
  75        }
  76}

        While the statement in the origin text may be against other
block devices, I get confused at first, so I modify the statement
to make it more clear.


Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>

---
 Documentation/filesystems/xip.txt |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/xip.txt
b/Documentation/filesystems/xip.txt
index 0466ee5..bef4120 100644
--- a/Documentation/filesystems/xip.txt
+++ b/Documentation/filesystems/xip.txt
@@ -35,8 +35,7 @@ is performed. A struct block_device reference is
used to address the device,
 and a sector_t argument is used to identify the individual block. As an
 alternative, memory technology devices can be used for this.

-The block device operation is optional, these block devices support it as of
-today:
+The block device operation is mandatory for execute-in-place, these
block devices support it as of today:
 - dcssblk: s390 dcss block device driver

 An address space operation named get_xip_mem is used to retrieve references
-- 
1.7.0.1


-- 


Thanks and Best Regards,
shenghui
