Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab0GAUgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:36:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57672 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab0GAUgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:36:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ZN3u1Pf92zsKlilf4x3+PtFreQ3SK91KOhM03GHvUTctfDiLnGv9wDACHB+/fau8mR
         bnmClEo+u6dTgOQDTmd227PJKP8jO3lJ4kaYajdMft4obCQJOHETbZeft4CXI6pHKtpz
         TVlDTL/dtKuYyJoPFd26hpf+e+o8rVelLsb24=
Message-ID: <4C2D187B.4020109@gmail.com>
Date: Fri, 02 Jul 2010 00:36:43 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] USB: Don't return 0 if writing the download record failed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the write download record failed we shouldn't return 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Maybe a different error value is more appropriate?

diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 0fca265..03696b9 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -1321,7 +1321,7 @@ static int download_fw(struct edgeport_serial *serial)
 				kfree(header);
 				kfree(rom_desc);
 				kfree(ti_manuf_desc);
-				return status;
+				return -EINVAL;
 			}
 
 			kfree(vheader);
