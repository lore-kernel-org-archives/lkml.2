Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab1EaLAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 07:00:42 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:53503 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab1EaLAl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 07:00:41 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
References: <1306834660-15374-1-git-send-email-geert@linux-m68k.org>
User-Agent: K-9 Mail for Android
In-Reply-To: <1306834660-15374-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 2/2] staging/iio: Make IIO depend on GENERIC_HARDIRQS
From: "jonathan.cameron@gmail.com" <jic23@cam.ac.uk>
Date: Tue, 31 May 2011 12:01:06 +0100
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jeff Mahoney <jeffm@suse.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Message-ID: <8eace637-27d2-41c5-bcbd-0087d6c75a75@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Geert Uytterhoeven <geert@linux-m68k.org> wrote:

>On m68k (which doesn't support generic hardirqs yet):
>
>drivers/staging/iio/industrialio-trigger.c: In function
>‘iio_trigger_poll’:
>drivers/staging/iio/industrialio-trigger.c:180: error: implicit
>declaration of function ‘generic_handle_irq’
>drivers/staging/iio/industrialio-trigger.c: In function
>‘iio_trigger_poll_chained’:
>drivers/staging/iio/industrialio-trigger.c:200: error: implicit
>declaration of function ‘handle_nested_irq’
>drivers/staging/iio/industrialio-trigger.c: In function
>‘iio_trig_release’:
>drivers/staging/iio/industrialio-trigger.c:379: error: implicit
>declaration of function ‘irq_modify_status’
>drivers/staging/iio/industrialio-trigger.c:382: error: implicit
>declaration of function ‘irq_set_chip’
>drivers/staging/iio/industrialio-trigger.c:384: error: implicit
>declaration of function ‘irq_set_handler’
>drivers/staging/iio/industrialio-trigger.c:388: error: implicit
>declaration of function ‘irq_free_descs’
>drivers/staging/iio/industrialio-trigger.c: In function
>‘iio_trig_subirqmask’:
>drivers/staging/iio/industrialio-trigger.c:402: error: implicit
>declaration of function ‘irq_data_get_irq_chip’
>drivers/staging/iio/industrialio-trigger.c:402: warning: initialization
>makes pointer from integer without a cast
>drivers/staging/iio/industrialio-trigger.c: In function
>‘iio_trig_subirqunmask’:
>drivers/staging/iio/industrialio-trigger.c:411: warning: initialization
>makes pointer from integer without a cast
>drivers/staging/iio/industrialio-trigger.c: In function
>‘iio_allocate_trigger’:
>drivers/staging/iio/industrialio-trigger.c:432: error: implicit
>declaration of function ‘irq_alloc_descs’
>drivers/staging/iio/industrialio-trigger.c:455: error:
>‘handle_simple_irq’ undeclared (first use in this function)
>drivers/staging/iio/industrialio-trigger.c:455: error: (Each undeclared
>identifier is reported only once
>drivers/staging/iio/industrialio-trigger.c:455: error: for each
>function it appears in.)
>
>Hence IIO_TRIGGER should depend on GENERIC_HARDIRQS.
>But as IIO_TRIGGER and IIO_RING_BUFFER form a maze of dependencies and
>selects,
>just make the whole IIO subsystem depend on GENERIC_HARDIRQS.
>
>This dependency also covers !S390, so that one can be removed again.
Dratt  We talked about this and thought S390 was the only non generic hard irq left.  Should have played safe sorry!
>Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
>---
> drivers/staging/iio/Kconfig |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/staging/iio/Kconfig b/drivers/staging/iio/Kconfig
>index f96d5b5..d329635 100644
>--- a/drivers/staging/iio/Kconfig
>+++ b/drivers/staging/iio/Kconfig
>@@ -4,7 +4,7 @@
> 
> menuconfig IIO
> 	tristate "Industrial I/O support"
>-	depends on !S390
>+	depends on GENERIC_HARDIRQS
> 	help
> 	  The industrial I/O subsystem provides a unified framework for
> 	  drivers for many different types of embedded sensors using a
>-- 
>1.7.0.4

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
