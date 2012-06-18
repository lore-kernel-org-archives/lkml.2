Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab2FRVpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 17:45:50 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:5779 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2FRVpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 17:45:49 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-209.messagelabs.com!1340055894!6241744!78
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: comedi_subdevice 'io_bits' should be an unsigned int
Date: Mon, 18 Jun 2012 14:45:42 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206181445.42744.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'io_bits' variable in the comedi_subdevice struct is a bitmask of
the input/output configuration of the the subdevice. It should be an
unsigned int to correctly represent this.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess: <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman: <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedidev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index e0f3915..7363fd8 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -78,7 +78,7 @@ struct comedi_subdevice {
 	unsigned runflags;
 	spinlock_t spin_lock;
 
-	int io_bits;
+	unsigned int io_bits;
 
 	unsigned int maxdata;	/* if maxdata==0, use list */
 	const unsigned int *maxdata_list;	/* list is channel specific */
-- 
1.7.11

