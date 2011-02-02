Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab1BBP6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 10:58:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468Ab1BBP57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 10:57:59 -0500
Date: Wed, 2 Feb 2011 10:55:06 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: Christoph Hellwig <hch@tuxera.com>
Cc: linux-kernel@vger.kernel.org
Subject: [Patch] hfsplus: Fix two memory leaks in wrapper.c
Message-ID: <20110202105507.3acd4a57@katamari>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-Off-By: Chuck Ebbert <cebbert@redhat.com>

--- vanilla-2.6.38-rc2-git9.orig/fs/hfsplus/wrapper.c
+++ vanilla-2.6.38-rc2-git9/fs/hfsplus/wrapper.c
@@ -167,7 +167,7 @@ reread:
 		break;
 	case cpu_to_be16(HFSP_WRAP_MAGIC):
 		if (!hfsplus_read_mdb(sbi->s_vhdr, &wd))
-			goto out;
+			goto out_free_backup_vhdr;
 		wd.ablk_size >>= HFSPLUS_SECTOR_SHIFT;
 		part_start += wd.ablk_start + wd.embed_start * wd.ablk_size;
 		part_size = wd.embed_count * wd.ablk_size;
@@ -179,7 +179,7 @@ reread:
 		 * (should do this only for cdrom/loop though)
 		 */
 		if (hfs_part_find(sb, &part_start, &part_size))
-			goto out;
+			goto out_free_backup_vhdr;
 		goto reread;
 	}
 
