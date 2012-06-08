Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761874Ab2FHFSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:18:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43255 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761283Ab2FHFHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:25 -0400
Message-Id: <20120608041846.480646831@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Theodore Tso <tytso@mit.edu>,
        Ken Sumrall <ksumrall@google.com>
Subject: [ 42/82] ext4: add missing save_error_info() to ext4_error()
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/super.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9f1ae6b..b8d5fc1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -539,6 +539,7 @@ void __ext4_error(struct super_block *sb, const char *function,
 	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: comm %s: %pV\n",
 	       sb->s_id, function, line, current->comm, &vaf);
 	va_end(args);
+	save_error_info(sb, function, line);
 
 	ext4_handle_error(sb);
 }


