Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030761Ab2CITsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:48:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030740Ab2CITr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:47:59 -0500
Message-Id: <20120309190205.960278401@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [ 45/95] viafb: fix IGA1 modesetting on VX900
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

commit e29206381a1436e0f47c0f5b9a23159a03c57715 upstream.

Even if the documentation calls this bit "Reserved" it has to be set
to 0 for correct modesetting on IGA1.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/via/hw.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1810,6 +1810,9 @@ static void hw_init(void)
 		break;
 	}
 
+	/* magic required on VX900 for correct modesetting on IGA1 */
+	via_write_reg_mask(VIACR, 0x45, 0x00, 0x01);
+
 	/* probably this should go to the scaling code one day */
 	via_write_reg_mask(VIACR, 0xFD, 0, 0x80); /* VX900 hw scale on IGA2 */
 	viafb_write_regx(scaling_parameters, ARRAY_SIZE(scaling_parameters));


