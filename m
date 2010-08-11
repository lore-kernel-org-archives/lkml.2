Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604Ab0HLAhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:37:01 -0400
Received: from kroah.org ([198.145.64.141]:43383 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759019Ab0HKX6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:30 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:00 2010
Message-Id: <20100811235500.690452892@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@newdream.net>, Chris Mason <chris.mason@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [056/111] Btrfs: fail mount on bad mount options
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sage Weil <sage@newdream.net>

commit a7a3f7cadd9bdee569243f7ead9550aa16b60e07 upstream.

We shouldn't silently ignore unrecognized options.

Signed-off-by: Sage Weil <sage@newdream.net>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/super.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -128,6 +128,7 @@ int btrfs_parse_options(struct btrfs_roo
 	substring_t args[MAX_OPT_ARGS];
 	char *p, *num;
 	int intarg;
+	int ret = 0;
 
 	if (!options)
 		return 0;
@@ -262,12 +263,18 @@ int btrfs_parse_options(struct btrfs_roo
 		case Opt_discard:
 			btrfs_set_opt(info->mount_opt, DISCARD);
 			break;
+		case Opt_err:
+			printk(KERN_INFO "btrfs: unrecognized mount option "
+			       "'%s'\n", p);
+			ret = -EINVAL;
+			goto out;
 		default:
 			break;
 		}
 	}
+out:
 	kfree(options);
-	return 0;
+	return ret;
 }
 
 /*


