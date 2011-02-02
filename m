Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1BBVPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:15:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44801 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab1BBVPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:15:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=e95ZBNMeonzJeCoQcllcjcZtATVX6JvZbQ4bjKOSVclmrb0LdWhN3LlZQq+FCAklzA
         MMm6PP+qpg0JXFZ5wDKXwTZF6gFnhMAgF9WHRUGjOcKGAxxkNlVq/d5j0ZVbXlvOUlqX
         mHcsN2j2Z4wUOM/SBaeX2OQsSMmPzGdlBQtaw=
Date: Thu, 3 Feb 2011 00:15:35 +0300
From: Alexey Charkov <alchark@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: Drop __exit attribute on btrfs_exit_compress
Message-ID: <20110202211535.GA13028@alchark-u3s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As this function is called in some error paths while not
removing the module, the __exit attribute prevents the kernel
image from linking when btrfs is compiled in statically.

Signed-off-by: Alexey Charkov <alchark@gmail.com>

---
I am not completely sure whether this has already been reported,
but googling around did not show any traces.

Best regards,
Alexey

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index f745287..db36b5e 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -900,7 +900,7 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 	return ret;
 }
 
-void __exit btrfs_exit_compress(void)
+void btrfs_exit_compress(void)
 {
 	free_workspaces();
 }
