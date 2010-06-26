Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab0FZMMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 08:12:21 -0400
Received: from mail-fx0-f66.google.com ([209.85.161.66]:36710 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab0FZMMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 08:12:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xr5VqQTLmUCCcXYMfTd6oACeypnPbu0nDjZmfeHenqLriLeaS3PT/1JwVucBJyJajf
         9yMuUsvleO11Q8t49ogb55JlS0kfWUp/1bcZJbb/oHoHULRuRq4PFgTKyVgNq7qJ4XXg
         cp9w4gxyQCv8sbUOcYJIvqFmxW0rwQj0esnPs=
From: Christoph Mair <christoph.mair@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       Stefan Schmidt <stefan@datenfreihafen.org>,
       Datta Shubhrajyoti <shubhrajyoti@ti.com>,
       Christoph Mair <christoph.mair@gmail.com>
Subject: [PATCH 2/2] bmp085: Add interface documentation and link to datasheet.
Date: Sat, 26 Jun 2010 13:10:24 +0200
Message-Id: <1277550624-13879-3-git-send-email-christoph.mair@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100621144958.d5fc694e.akpm@linux-foundation.org>
References: <20100621144958.d5fc694e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Mair <christoph.mair@gmail.com>
---
 drivers/misc/bmp085.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index 16a2b2c..67ed8b2 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -1,5 +1,32 @@
 /*  Copyright (c) 2010  Christoph Mair <christoph.mair@gmail.com>
 
+    This driver supports the bmp085 digital barometric pressure
+    and temperature sensor from Bosch Sensortec. The datasheet
+    is avaliable from their website:
+    http://www.bosch-sensortec.com/content/language1/downloads/BST-BMP085-DS000-05.pdf
+
+    A pressure measurement is issued by reading from pressure0_input.
+    The return value ranges from 30000 to 110000 pascal with a resulution
+    of 1 pascal (0.01 millibar) which enables measurements from 9000m above
+    to 500m below sea level.
+
+    The temperature can be read from temp0_input. Values range from
+    -400 to 850 representing the ambient temperature in degree celsius
+    multiplied by 10.The resolution is 0.1 celsius.
+
+    Because ambient pressure is temperature dependent, a temperature
+    measurement will be executed automatically even if the user is reading
+    from pressure0_input. This happens if the last temperature measurement
+    has been executed more then one second ago.
+
+    To decrease RMS noise from pressure measurements, the bmp085 can
+    autonomously calculate the average of up to eight samples. This is
+    set up by writing to the oversampling sysfs file. Accepted values
+    are 0, 1, 2 and 3. 2^x when x is the value written to this file
+    specifies the number of samples used to calculate the ambient pressure.
+    RMS noise is specified with six pascal (without averaging) and decreases
+    down to 3 pascal when using an oversampling setting of 3.
+
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation; either version 2 of the License, or
-- 
1.7.1

