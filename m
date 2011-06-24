Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884Ab1FXQ2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 12:28:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20829 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1FXQ2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 12:28:50 -0400
Date: Fri, 24 Jun 2011 09:28:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Jonathan Cameron <jic23@cam.ac.uk>, gregkh <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-iio@vger.kernel.org
Subject: [PATCH] staging: fix more iio builds when IIO_RING_BUFFER is not
 enabled
Message-Id: <20110624092832.36ef2eae.randy.dunlap@oracle.com>
In-Reply-To: <20110624155822.cb8cf6eb.sfr@canb.auug.org.au>
References: <20110624155822.cb8cf6eb.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E04BB3A.009C:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix lots more build errors in staging/iio when CONFIG_IIO_RING_BUFFER
is not enabled by moving enums and defines outside of the
CONFIG_IIO_RING_BUFFER ifdef block.

Examples (one from each driver; there were 116 total errors):

drivers/staging/iio/accel/adis16204_core.c:437: error: 'ADIS16204_SCAN_SUPPLY' undeclared here (not in a function)
drivers/staging/iio/accel/adis16209_core.c:410: error: 'ADIS16209_SCAN_SUPPLY' undeclared here (not in a function)
drivers/staging/iio/gyro/adis16260_core.c:420: error: 'ADIS16260_SCAN_GYRO' undeclared here (not in a function)
drivers/staging/iio/imu/adis16400_core.c:565: error: 'ADIS16400_SCAN_SUPPLY' undeclared here (not in a function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-iio@vger.kernel.org
---
 drivers/staging/iio/accel/adis16204.h |    2 +-
 drivers/staging/iio/accel/adis16209.h |    4 ++--
 drivers/staging/iio/gyro/adis16260.h  |    2 +-
 drivers/staging/iio/imu/adis16400.h   |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- linux-next-20110624.orig/drivers/staging/iio/accel/adis16204.h
+++ linux-next-20110624/drivers/staging/iio/accel/adis16204.h
@@ -84,7 +84,6 @@ struct adis16204_state {
 
 int adis16204_set_irq(struct iio_dev *indio_dev, bool enable);
 
-#ifdef CONFIG_IIO_RING_BUFFER
 enum adis16204_scan {
 	ADIS16204_SCAN_SUPPLY,
 	ADIS16204_SCAN_ACC_X,
@@ -93,6 +92,7 @@ enum adis16204_scan {
 	ADIS16204_SCAN_TEMP,
 };
 
+#ifdef CONFIG_IIO_RING_BUFFER
 void adis16204_remove_trigger(struct iio_dev *indio_dev);
 int adis16204_probe_trigger(struct iio_dev *indio_dev);
 
--- linux-next-20110624.orig/drivers/staging/iio/accel/adis16209.h
+++ linux-next-20110624/drivers/staging/iio/accel/adis16209.h
@@ -121,8 +121,6 @@ struct adis16209_state {
 
 int adis16209_set_irq(struct iio_dev *indio_dev, bool enable);
 
-#ifdef CONFIG_IIO_RING_BUFFER
-
 #define ADIS16209_SCAN_SUPPLY	0
 #define ADIS16209_SCAN_ACC_X	1
 #define ADIS16209_SCAN_ACC_Y	2
@@ -132,6 +130,8 @@ int adis16209_set_irq(struct iio_dev *in
 #define ADIS16209_SCAN_INCLI_Y	6
 #define ADIS16209_SCAN_ROT	7
 
+#ifdef CONFIG_IIO_RING_BUFFER
+
 void adis16209_remove_trigger(struct iio_dev *indio_dev);
 int adis16209_probe_trigger(struct iio_dev *indio_dev);
 
--- linux-next-20110624.orig/drivers/staging/iio/gyro/adis16260.h
+++ linux-next-20110624/drivers/staging/iio/gyro/adis16260.h
@@ -104,7 +104,6 @@ struct adis16260_state {
 
 int adis16260_set_irq(struct iio_dev *indio_dev, bool enable);
 
-#ifdef CONFIG_IIO_RING_BUFFER
 /* At the moment triggers are only used for ring buffer
  * filling. This may change!
  */
@@ -115,6 +114,7 @@ int adis16260_set_irq(struct iio_dev *in
 #define ADIS16260_SCAN_TEMP	3
 #define ADIS16260_SCAN_ANGL	4
 
+#ifdef CONFIG_IIO_RING_BUFFER
 void adis16260_remove_trigger(struct iio_dev *indio_dev);
 int adis16260_probe_trigger(struct iio_dev *indio_dev);
 
--- linux-next-20110624.orig/drivers/staging/iio/imu/adis16400.h
+++ linux-next-20110624/drivers/staging/iio/imu/adis16400.h
@@ -158,7 +158,6 @@ struct adis16400_state {
 
 int adis16400_set_irq(struct iio_dev *indio_dev, bool enable);
 
-#ifdef CONFIG_IIO_RING_BUFFER
 /* At the moment triggers are only used for ring buffer
  * filling. This may change!
  */
@@ -182,6 +181,7 @@ int adis16400_set_irq(struct iio_dev *in
 #define ADIS16300_SCAN_INCLI_X	12
 #define ADIS16300_SCAN_INCLI_Y	13
 
+#ifdef CONFIG_IIO_RING_BUFFER
 void adis16400_remove_trigger(struct iio_dev *indio_dev);
 int adis16400_probe_trigger(struct iio_dev *indio_dev);
 
