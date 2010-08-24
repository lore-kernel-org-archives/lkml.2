Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab0HXXBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:01:07 -0400
Received: from kroah.org ([198.145.64.141]:40757 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932614Ab0HXXBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:01:00 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:01 2010
Message-Id: <20100824224501.368359170@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>
Subject: [001/114] memstick: init sysfs attributes
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maxim Levitsky <maximlevitsky@gmail.com>

commit 21fd0495ea61d53e0ebe575330e343ce4e6d2a61 upstream.

Otherwise lockdep complains.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/memstick/core/mspro_block.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1040,6 +1040,7 @@ static int mspro_block_read_attributes(s
 			snprintf(s_attr->name, sizeof(s_attr->name),
 				 "attr_x%02x", attr->entries[cnt].id);
 
+		sysfs_attr_init(&s_attr->dev_attr.attr);
 		s_attr->dev_attr.attr.name = s_attr->name;
 		s_attr->dev_attr.attr.mode = S_IRUGO;
 		s_attr->dev_attr.show = mspro_block_attr_show(s_attr->id);


