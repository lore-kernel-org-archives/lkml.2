Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab0K3OGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:06:13 -0500
Received: from fire-ce0.netis.ru ([193.233.48.99]:53956 "EHLO fire.netis.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab0K3OGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:06:12 -0500
X-Greylist: delayed 743 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Nov 2010 09:06:11 EST
Date: Tue, 30 Nov 2010 16:52:20 +0300
From: "Alexander V. Lukyanov" <lav@netis.ru>
To: linux-ext4@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] allow inode_readahead_blks=0
Message-ID: <20101130135219.GA22357@proxy>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-NETIS-MailScanner-Information: Please contact NETIS Telecom for more information <info@netis.ru> (+7 4852 797797)
X-NETIS-MailScanner-ID: oAUDqMDq022395
X-NETIS-MailScanner: Found to be clean
X-NETIS-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0.001, required 6, autolearn=disabled, FSL_RU_URL 0.00)
X-NETIS-MailScanner-From: root@proxy.yar.ru
X-NETIS-MailScanner-To: adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, tytso@mit.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello!

Currently the value 0 is disallowed, as it is not a power of 2.

This obvious patch fixes the problem.

Signed-off-by: Alexander V. Lukyanov <lav@netis.ru>

-- 
   Alexander.

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=diff

--- fs/ext4/super.c.0	2010-11-16 10:48:33.418629215 +0300
+++ fs/ext4/super.c	2010-11-16 10:46:07.739753246 +0300
@@ -1657,7 +1657,7 @@ set_qf_format:
 				return 0;
 			if (option < 0 || option > (1 << 30))
 				return 0;
-			if (!is_power_of_2(option)) {
+			if (option && !is_power_of_2(option)) {
 				ext4_msg(sb, KERN_ERR,
 					 "EXT4-fs: inode_readahead_blks"
 					 " must be a power of 2");
@@ -2274,7 +2274,7 @@ static ssize_t inode_readahead_blks_stor
 	if (parse_strtoul(buf, 0x40000000, &t))
 		return -EINVAL;
 
-	if (!is_power_of_2(t))
+	if (t && !is_power_of_2(t))
 		return -EINVAL;
 
 	sbi->s_inode_readahead_blks = t;

--LQksG6bCIzRHxTLp--
