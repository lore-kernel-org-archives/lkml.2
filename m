Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab0LHArO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:47:14 -0500
Received: from kroah.org ([198.145.64.141]:46100 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082Ab0LHArM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:12 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:29 2010
Message-Id: <20101208004429.094793784@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        maximilian attems <max@stro.at>
Subject: [048/127] firewire: core: fix an information leak
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 137d9ebfdbaa45c01f9f0f6d5121ae6f1eb942bd upstream.

If a device exposes a sparsely populated configuration ROM,
firewire-core's sysfs interface and character device file interface
showed random data in the gaps between config ROM blocks.  Fix this by
zero-initialization of the config ROM reader's scratch buffer.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/core-device.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -463,6 +463,7 @@ static int read_bus_info_block(struct fw
 		return -ENOMEM;
 
 	stack = &rom[READ_BIB_ROM_SIZE];
+	memset(rom, 0, sizeof(*rom) * READ_BIB_ROM_SIZE);
 
 	device->max_speed = SCODE_100;
 


