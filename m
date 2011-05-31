Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1EaJhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 05:37:47 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:48003 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1EaJhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 05:37:46 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jeff Mahoney <jeffm@suse.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] staging/iio: Make IIO depend on GENERIC_HARDIRQS
Date: Tue, 31 May 2011 11:37:40 +0200
Message-Id: <1306834660-15374-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On m68k (which doesn't support generic hardirqs yet):

drivers/staging/iio/industrialio-trigger.c: In function ‘iio_trigger_poll’:
drivers/staging/iio/industrialio-trigger.c:180: error: implicit declaration of function ‘generic_handle_irq’
drivers/staging/iio/industrialio-trigger.c: In function ‘iio_trigger_poll_chained’:
drivers/staging/iio/industrialio-trigger.c:200: error: implicit declaration of function ‘handle_nested_irq’
drivers/staging/iio/industrialio-trigger.c: In function ‘iio_trig_release’:
drivers/staging/iio/industrialio-trigger.c:379: error: implicit declaration of function ‘irq_modify_status’
drivers/staging/iio/industrialio-trigger.c:382: error: implicit declaration of function ‘irq_set_chip’
drivers/staging/iio/industrialio-trigger.c:384: error: implicit declaration of function ‘irq_set_handler’
drivers/staging/iio/industrialio-trigger.c:388: error: implicit declaration of function ‘irq_free_descs’
drivers/staging/iio/industrialio-trigger.c: In function ‘iio_trig_subirqmask’:
drivers/staging/iio/industrialio-trigger.c:402: error: implicit declaration of function ‘irq_data_get_irq_chip’
drivers/staging/iio/industrialio-trigger.c:402: warning: initialization makes pointer from integer without a cast
drivers/staging/iio/industrialio-trigger.c: In function ‘iio_trig_subirqunmask’:
drivers/staging/iio/industrialio-trigger.c:411: warning: initialization makes pointer from integer without a cast
drivers/staging/iio/industrialio-trigger.c: In function ‘iio_allocate_trigger’:
drivers/staging/iio/industrialio-trigger.c:432: error: implicit declaration of function ‘irq_alloc_descs’
drivers/staging/iio/industrialio-trigger.c:455: error: ‘handle_simple_irq’ undeclared (first use in this function)
drivers/staging/iio/industrialio-trigger.c:455: error: (Each undeclared identifier is reported only once
drivers/staging/iio/industrialio-trigger.c:455: error: for each function it appears in.)

Hence IIO_TRIGGER should depend on GENERIC_HARDIRQS.
But as IIO_TRIGGER and IIO_RING_BUFFER form a maze of dependencies and selects,
just make the whole IIO subsystem depend on GENERIC_HARDIRQS.

This dependency also covers !S390, so that one can be removed again.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/iio/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/Kconfig b/drivers/staging/iio/Kconfig
index f96d5b5..d329635 100644
--- a/drivers/staging/iio/Kconfig
+++ b/drivers/staging/iio/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig IIO
 	tristate "Industrial I/O support"
-	depends on !S390
+	depends on GENERIC_HARDIRQS
 	help
 	  The industrial I/O subsystem provides a unified framework for
 	  drivers for many different types of embedded sensors using a
-- 
1.7.0.4

