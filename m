Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab2FTWsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:48:06 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:47010 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670Ab2FTWsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:48:00 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 00/15] Android ETM driver changes
Date: Wed, 20 Jun 2012 18:47:32 -0400
Message-Id: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062022-4242-0000-0000-0000020E413F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I didn't hear any objections to the earlier RFC release
last week, I wanted to send this on for inclusion.

The Android kernel tree has a number of changes to the ETM driver.
Arve sent the first 9 of these to the list over a year ago and
got very little response.

I didn't want these to get lost, so I pinged Alexander about
these privately and he stated that he wasn't actively
maintaining the driver, but after skimming the entire set he
acked the series and suggested I send it on to Russel for
review and inclusion.

thanks
-john


CC: Russell King <linux@arm.linux.org.uk>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
CC: Arve Hjønnevåg <arve@android.com>

Arve Hjønnevåg (15):
  ARM: etm: Don't require clock control
  ARM: etm: Don't limit tracing to only non-secure code.
  ARM: etm: Don't try to clear the buffer full status after reading the
    buffer
  ARM: etm: Allow range selection
  ARM: etm: Configure data tracing
  ARM: etm: Add some missing locks and error checks
  ARM: etm: Return the entire trace buffer if it is empty after reset
  ARM: etm: Support multiple ETMs/PTMs.
  ARM: etm: Power down etm(s) when tracing is not enabled
  ARM: etm: Wait for etm/ptm(s) to stop before requesting PowerDown
  ARM: etm: Check arch version and disable data tracing for ptm
  ARM: etm: Add sysfs entry to enable timestamps if supported
  ARM: etm: Add sysfs entry to set context-id-size
  ARM: etm: Add sysfs entry to disable branch_output flag
  ARM: etm: Add sysfs entry to enable return stack if supported

 arch/arm/include/asm/hardware/coresight.h |   50 ++-
 arch/arm/kernel/etm.c                     |  680 +++++++++++++++++++++++------
 2 files changed, 587 insertions(+), 143 deletions(-)

-- 
1.7.9.5

