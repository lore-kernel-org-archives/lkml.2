Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1C2DSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 23:18:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36988 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab1C2DSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 23:18:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=tHyWFBfX9Kxwd35DXU+kkORSRkfuGgx6+kulJCj/XLBAyqLqXtvXpdeYB9lXk/Asu9
         2HSypZOux/Pshm1nGxEQha2j1u2qxJWWgbFI03fDYUdjYYpBchMZ/YZOyNyREskL+8r8
         9OBIsErxKNYfZ+wqgtUYu4cLvgzcviAl7C8nw=
Date: Tue, 29 Mar 2011 06:18:04 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] tcm_loop: off by one in tcm_loop_make_naa_tpg()
Message-ID: <20110329031804.GB9856@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	James Bottomley <James.Bottomley@suse.de>,
	Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an off by one that could result in memory corruption.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index aed4e46..2bb5062 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1239,7 +1239,7 @@ struct se_portal_group *tcm_loop_make_naa_tpg(
 	tpgt_str += 5; /* Skip ahead of "tpgt_" */
 	tpgt = (unsigned short int) simple_strtoul(tpgt_str, &end_ptr, 0);
 
-	if (tpgt > TL_TPGS_PER_HBA) {
+	if (tpgt >= TL_TPGS_PER_HBA) {
 		printk(KERN_ERR "Passed tpgt: %hu exceeds TL_TPGS_PER_HBA:"
 				" %u\n", tpgt, TL_TPGS_PER_HBA);
 		return ERR_PTR(-EINVAL);
