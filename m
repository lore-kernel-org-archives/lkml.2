Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab2HMUU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:20:59 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49138 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab2HMUUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:20:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 13/82] media: m5mols: Correct reported ISO values
Date: Mon, 13 Aug 2012 13:18:49 -0700
Message-Id: <20120813201747.587240307@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

commit 6126b912c84240692e26c1b820a7097610eddf34 upstream.

The V4L2_CID_ISO_SENSITIVITY control menu values should be
standard ISO values multiplied by 1000. Multiply all menu
items by 1000 so ISO is properly reported as 50...3200 range.

This applies to kernels 3.5+.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/m5mols/m5mols_controls.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -527,8 +527,8 @@ static const struct v4l2_ctrl_ops m5mols
 
 /* Supported manual ISO values */
 static const s64 iso_qmenu[] = {
-	/* AE_ISO: 0x01...0x07 */
-	50, 100, 200, 400, 800, 1600, 3200
+	/* AE_ISO: 0x01...0x07 (ISO: 50...3200) */
+	50000, 100000, 200000, 400000, 800000, 1600000, 3200000
 };
 
 /* Supported Exposure Bias values, -2.0EV...+2.0EV */


