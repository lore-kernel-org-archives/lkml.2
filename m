Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab0FZLMK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 07:12:10 -0400
Received: from mail-fx0-f66.google.com ([209.85.161.66]:33511 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab0FZLMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 07:12:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DAU9CucsPwAkikScfT8tgtM7914DY+5xQVtvHqH9APw2JmRlNW59TQ6FULUWuATCZH
         NEMvLz0dWQadz4KIcKvw5uXSwZNk4zk5bI59m/3qTtC/4z6U744f1iE6980aj6ye9oV4
         XUIWoq6DQUMxYQeRk2ncwoEn9OFQEBdDkRdJQ=
From: Christoph Mair <christoph.mair@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       Stefan Schmidt <stefan@datenfreihafen.org>,
       Datta Shubhrajyoti <shubhrajyoti@ti.com>,
       Christoph Mair <christoph.mair@gmail.com>
Subject: [PATCH 1/2] Add ABI documentation for the bmp085 digital pressure sensor.
Date: Sat, 26 Jun 2010 13:10:23 +0200
Message-Id: <1277550624-13879-2-git-send-email-christoph.mair@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100621144958.d5fc694e.akpm@linux-foundation.org>
References: <20100621144958.d5fc694e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Mair <christoph.mair@gmail.com>
---
 Documentation/ABI/testing/sysfs-i2c-bmp085 |   31 ++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-i2c-bmp085

diff --git a/Documentation/ABI/testing/sysfs-i2c-bmp085 b/Documentation/ABI/testing/sysfs-i2c-bmp085
new file mode 100644
index 0000000..585962a
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-i2c-bmp085
@@ -0,0 +1,31 @@
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/pressure0_input
+Date:		June 2010
+Contact:	Christoph Mair <christoph.mair@gmail.com>
+Description:	Start a pressure measurement and read the result. Values
+		represent the ambient air pressure in pascal (0.01 millibar).
+
+		Reading: returns the current air pressure.
+
+
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/temp0_input
+Date:		June 2010
+Contact:	Christoph Mair <christoph.mair@gmail.com>
+Description:	Measure the ambient temperature. The returned value represents
+		the ambient temperature in units of 0.1 degree celsius.
+
+		Reading: returns the current temperature.
+
+
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/oversampling
+Date:		June 2010
+Contact:	Christoph Mair <christoph.mair@gmail.com>
+Description:	Tell the bmp085 to use more samples to calculate a pressure
+		value. When writing to this file the chip will use 2^x samples
+		to calculate the next pressure value with x being the value
+		written. Using this feature will decrease RMS noise and
+		increase the measurement time.
+
+		Reading: returns the current oversampling setting.
+
+		Writing: sets a new oversampling setting.
+		Accepted values: 0..3.
-- 
1.7.1

