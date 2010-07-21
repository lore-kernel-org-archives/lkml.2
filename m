Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761969Ab0GUA6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 20:58:25 -0400
Received: from p01c12o149.mxlogic.net ([208.65.145.72]:55972 "EHLO
	p01c12o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761917Ab0GUA6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 20:58:23 -0400
X-MXL-Hash: 4c46462f7d75e20c-69e60abb259afdbad5aa9c248de91e3bf9a00db7
X-MXL-Hash: 4c4646261f595a39-705fcfdf33ffe2629c86def442efe6613d038322
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: dt3155: Remove copy_to_user for ioctl's DT3155_{STOP|START}
Date: Tue, 20 Jul 2010 17:57:52 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@suse.de>, <ss@aao.gov.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201007201757.52928.hartleys@visionengravers.com>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010070601)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.32]
X-AnalysisOut: [v=1.0 c=1 a=WxJHxwW4_00A:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=zbe46bahRtDx8aUBN1lPzQ==:17 a=i00gxMtYAAAA:8 a=WZj]
X-AnalysisOut: [COqObcBZspbat1VkA:9 a=-LpK7zv8LvNQ7Ctx9pWQun0V6ikA:4 a=QEX]
X-AnalysisOut: [dDO2ut3YA:10 a=x1WnkoZAwusA:10 a=0kPLrQdw3YYA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioctl's DT3155_STOP and DT3155_START are defined with the macro
_IO indicating that they have no parameters. They should not be using
copy_to_user to return data to user space.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index fed7e62..5eb1bcd 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -570,8 +570,6 @@ static int dt3155_ioctl(struct inode *inode,
 	  return 0;
 
 	quick_stop(minor);
-	if (copy_to_user(up, dts, sizeof(*dts)))
-	    return -EFAULT;
 	return 0;
       }
     case DT3155_START:
@@ -593,8 +591,6 @@ static int dt3155_ioctl(struct inode *inode,
 	  }
 
 	dt3155_init_isr(minor);
-	if (copy_to_user(up, dts, sizeof(*dts)))
-	    return -EFAULT;
 	return 0;
       }
     default:
