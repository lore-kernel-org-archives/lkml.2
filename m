Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab2FGEU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:20:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59627 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab2FGEUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:20:22 -0400
Message-Id: <20120607040345.580594993@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:39 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ken Sumrall <ksumrall@google.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 63/82] ext4: add missing save_error_info() to ext4_error()
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit f3fc0210c0fc91900766c995f089c39170e68305 upstream.

The ext4_error() function is missing a call to save_error_info().
Since this is the function which marks the file system as containing
an error, this oversight (which was introduced in 2.6.36) is quite
significant, and should be backported to older stable kernels with
high urgency.

Reported-by: Ken Sumrall <ksumrall@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: ksumrall@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -497,6 +497,7 @@ void __ext4_error(struct super_block *sb
 	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: comm %s: %pV\n",
 	       sb->s_id, function, line, current->comm, &vaf);
 	va_end(args);
+	save_error_info(sb, function, line);
 
 	ext4_handle_error(sb);
 }


