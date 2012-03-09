Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030777Ab2CITs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:48:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030740Ab2CITsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:48:24 -0500
Message-Id: <20120309190205.886356730@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [ 44/95] viafb: select HW scaling on VX900 for IGA2
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

commit 050f0e02c8dc38b2b4f2df345ac760d22ca5c7ba upstream.

VX900 can do hardware scaling for both IGAs in contrast to previous
hardware which could do it only for IGA2. This patch ensures that
we set the parameter for IGA2 and not for IGA1. This fixes hardware
scaling on VX900 until we have the infrastructure to support it for
both IGAs.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/via/hw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1811,6 +1811,7 @@ static void hw_init(void)
 	}
 
 	/* probably this should go to the scaling code one day */
+	via_write_reg_mask(VIACR, 0xFD, 0, 0x80); /* VX900 hw scale on IGA2 */
 	viafb_write_regx(scaling_parameters, ARRAY_SIZE(scaling_parameters));
 
 	/* Fill VPIT Parameters */


