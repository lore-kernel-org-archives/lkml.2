Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab1KMNFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 08:05:52 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:47778 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1KMNFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 08:05:51 -0500
Subject: [PATCH] staging: iio: drop "select IIO_SIMPLE_DUMMY_EVGEN"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jonathan Cameron <jic23@cam.ac.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Nov 2011 14:05:45 +0100
Message-ID: <1321189545.20271.59.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e6477000fc ("staging:iio:dummy Add event support + fake event
generator") added "select IIO_SIMPLE_DUMMY_EVGEN if [...]". But there
is no Kconfig symbol named IIO_SIMPLE_DUMMY_EVGEN. The select statement
for that symbol is a nop. Drop it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with "make menuconfig" before and after applying this patch.
Identical .config files were generated, as was expected.

1) The "select IIO_DUMMY_EVGEN" of the IIO_SIMPLE_DUMMY_EVENTS Kconfig
entry probably does what was intended here. Maybe that's why no one
noticed.

 drivers/staging/iio/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/Kconfig b/drivers/staging/iio/Kconfig
index 4ec9118..90162aa 100644
--- a/drivers/staging/iio/Kconfig
+++ b/drivers/staging/iio/Kconfig
@@ -76,7 +76,6 @@ config IIO_DUMMY_EVGEN
 
 config IIO_SIMPLE_DUMMY
        tristate "An example driver with no hardware requirements"
-       select IIO_SIMPLE_DUMMY_EVGEN if IIO_SIMPLE_DUMMY_EVENTS
        help
 	 Driver intended mainly as documentation for how to write
 	 a driver. May also be useful for testing userspace code
-- 
1.7.4.4



