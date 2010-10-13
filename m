Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab0JMNpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:45:36 -0400
Received: from smtp.nokia.com ([192.100.122.230]:40516 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab0JMNpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:45:34 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: khali@linux-fr.org, tony@atomide.com
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Short timeout for I2C transfers
Date: Wed, 13 Oct 2010 16:45:08 +0300
Message-Id: <1286977510-16702-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 13 Oct 2010 13:45:15.0096 (UTC) FILETIME=[DD74CD80:01CB6ADC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are chips which doesn't work perfectly in certain
I2C operations. For example lp5523 led driver chip causes
always I2C timeout when SW reset is commanded to the chip.

Patches add a possibility to tell that this access is likely
to cause time out and there is no need to wait normal time.
For example in omap time out is 1 second and the bus is reserved
all the time.
By setting I2C_M_SHORT_TIMEOUT flag to i2c-message, adapter is
requested to use shorter timeout.

Samu Onkalo (2):
  drivers: i2c-core: Add a flag to allow short timeout
  drivers: i2c-omap: Add support for shorten I2C timeout

 drivers/i2c/busses/i2c-omap.c |    9 ++++++++-
 drivers/i2c/i2c-core.c        |    2 +-
 include/linux/i2c.h           |    1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

