Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693Ab0JVTJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:09:37 -0400
Received: from kroah.org ([198.145.64.141]:34205 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759387Ab0JVS4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:35 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:32 2010
Message-Id: <20101022185232.281189317@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [055/103] wext: fix potential private ioctl memory content leak
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit df6d02300f7c2fbd0fbe626d819c8e5237d72c62 upstream.

When a driver doesn't fill the entire buffer, old
heap contents may remain, and if it also doesn't
update the length properly, this old heap content
will be copied back to userspace.

It is very unlikely that this happens in any of
the drivers using private ioctls since it would
show up as junk being reported by iwpriv, but it
seems better to be safe here, so use kzalloc.

Reported-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/wext-priv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/wext-priv.c
+++ b/net/wireless/wext-priv.c
@@ -152,7 +152,7 @@ static int ioctl_private_iw_point(struct
 	} else if (!iwp->pointer)
 		return -EFAULT;
 
-	extra = kmalloc(extra_size, GFP_KERNEL);
+	extra = kzalloc(extra_size, GFP_KERNEL);
 	if (!extra)
 		return -ENOMEM;
 


