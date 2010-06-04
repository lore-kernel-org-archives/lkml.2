Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0FDK2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 06:28:13 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:46237 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab0FDK2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 06:28:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=dwHGzV6smkbKbNnKjt5JgvWIXOh+eWrzuNBA60it3xgWP2gxf3oO/m1DBdZOmMPhQv
         +KXCMUEoaYw/5LEC4Mge+++Gd4gEcetymsD1qLcdAXy9pY5OWwpUR9Hxm4SLZmyErTzY
         SLEd+pUsGf4ZgUHm7r5Yqq2nbf8LRh7sth5mM=
Date: Fri, 4 Jun 2010 12:20:46 +0200
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] vt_ioctl: return -EFAULT on copy_from_user errors
Message-ID: <20100604102046.GY5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_from_user() returns the number of bytes remaining but we want to
return a negative error code here.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 6aa1028..cb19dbc 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -1303,7 +1303,9 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		if (!perm)
 			goto eperm;
 		ret = copy_from_user(&ui, up, sizeof(struct unimapinit));
-		if (!ret)
+		if (ret)
+			ret = -EFAULT;
+		else
 			con_clear_unimap(vc, &ui);
 		break;
 	      }
