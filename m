Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab0IXQlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:41:46 -0400
Received: from kroah.org ([198.145.64.141]:37246 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057Ab0IXQf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:29 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:47 2010
Message-Id: <20100924163347.568982799@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [40/68] drivers/video/via/ioctl.c: prevent reading uninitialized stack memory
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit b4aaa78f4c2f9cde2f335b14f4ca30b01f9651ca upstream.

The VIAFB_GET_INFO device ioctl allows unprivileged users to read 246
bytes of uninitialized stack memory, because the "reserved" member of
the viafb_ioctl_info struct declared on the stack is not altered or
zeroed before being copied back to the user.  This patch takes care of
it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/via/ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/video/via/ioctl.c
+++ b/drivers/video/via/ioctl.c
@@ -25,6 +25,8 @@ int viafb_ioctl_get_viafb_info(u_long ar
 {
 	struct viafb_ioctl_info viainfo;
 
+	memset(&viainfo, 0, sizeof(struct viafb_ioctl_info));
+
 	viainfo.viafb_id = VIAID;
 	viainfo.vendor_id = PCI_VIA_VENDOR_ID;
 


