Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab0HKX7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:59:05 -0400
Received: from kroah.org ([198.145.64.141]:43473 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759012Ab0HKX6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:45 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:01 2010
Message-Id: <20100811235501.870761315@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yang Hongyang <yanghy@cn.fujitsu.com>,
        Chris Mason <chris.mason@oracle.com>, Jeff Mahoney <jeffm@suse.com>
Subject: [069/111] Btrfs: fix a memory leak in btrfs_init_acl
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yang Hongyang <yanghy@cn.fujitsu.com>

commit f858153c367a397235d3e81136741e40e44faf1d upstream.

In btrfs_init_acl() cloned acl is not released

Signed-off-by: Yang Hongyang <yanghy@cn.fujitsu.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/btrfs/acl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -272,6 +272,7 @@ int btrfs_init_acl(struct btrfs_trans_ha
 						    ACL_TYPE_ACCESS);
 			}
 		}
+		posix_acl_release(clone);
 	}
 failed:
 	posix_acl_release(acl);


