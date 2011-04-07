Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab1DGOgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 10:36:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63153 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab1DGOgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 10:36:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=Pth1K/6G13TZIzUMxf06oBs02vYgLN7g7e2/vrBV81LVUWt8FglLXiJR9RAW4zADVT
         W9JkBzD6jqbZA14wKMOR0AaW/kWEgoxFHm/f+Sb3j+AQJ6kokFJQsx7xfOLBXxGXYs/W
         FoZ1uQoPkM4v5GpC9+Gi1d9iFGwYZQTyhhEmk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=5Ddrivers=3Astaging=3Ahv=3Ahv=5Fmouse=2Ec=20Fix=20build=20error=20in=20hv=5Fmouse=2E?=
Date: Thu,  7 Apr 2011 07:36:36 -0700
Message-Id: <1302186996-23392-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below fixes a build error..

  LD [M]  drivers/staging/hv/hv_utils.o
  CC [M]  drivers/staging/hv/hv_mouse.o
drivers/staging/hv/hv_mouse.c: In function ‘ReleaseInputDevice’:
drivers/staging/hv/hv_mouse.c:293:3: error: implicit declaration of function ‘udelay’ [-Werror=implicit-function-declaration]
drivers/staging/hv/hv_mouse.c: In function ‘MousevscOnReceiveInputReport’:
drivers/staging/hv/hv_mouse.c:418:27: warning: variable ‘inputDriver’ set but not used [-Wunused-but-set-variable]
drivers/staging/hv/hv_mouse.c: In function ‘MousevscOnDeviceAdd’:
drivers/staging/hv/hv_mouse.c:663:27: warning: variable ‘inputDriver’ set but not used [-Wunused-but-set-variable]
cc1: some warnings being treated as errors

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/hv/hv_mouse.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 50147f8..9c6d4d2 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -23,6 +23,7 @@
 #include <linux/hiddev.h>
 #include <linux/pci.h>
 #include <linux/dmi.h>
+#include <linux/delay.h>
 
 #include "hv_api.h"
 #include "logging.h"
-- 
1.7.4.2

