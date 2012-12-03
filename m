Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2LCHl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 02:41:27 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:51490 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab2LCHl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 02:41:26 -0500
Date: Mon, 3 Dec 2012 08:41:16 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Vitalii Demianets <vitas@nppfactor.kiev.ua>, Tux9 <tuxding@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] stable: uio: Fix warning: 'ret' might be used uninitialized
Message-ID: <20121203074116.GB7723@local>
References: <201211271348.14603.vitas@nppfactor.kiev.ua>
 <201211291836.59358.vitas@nppfactor.kiev.ua>
 <20121129235822.GA2590@local>
 <201211301316.19217.vitas@nppfactor.kiev.ua>
 <20121130213906.GB2603@local>
 <20121130234331.GD17353@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130234331.GD17353@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In two cases, the return value variable "ret" can be undefined.

Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
Reported-by: Vitalii Demianets <vitas@nppfactor.kiev.ua>

---
 drivers/uio/uio.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 5110f36..0c80df2 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -273,6 +273,7 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 	struct uio_portio *portio;
 
 	for (mi = 0; mi < MAX_UIO_MAPS; mi++) {
+		ret = -ENOMEM;
 		mem = &idev->info->mem[mi];
 		if (mem->size == 0)
 			break;
@@ -298,6 +299,7 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 	}
 
 	for (pi = 0; pi < MAX_UIO_PORT_REGIONS; pi++) {
+		ret = -ENOMEM;
 		port = &idev->info->port[pi];
 		if (port->size == 0)
 			break;
-- 
1.7.9

