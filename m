Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab1EFWJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:09:46 -0400
Received: from mail.atheros.com ([12.19.149.2]:15463 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1EFWJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:09:44 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <akpm@linux-foundation.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
        <hpa@zytor.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <allen.kao@atheros.com>,
        <roman.gezikov@atheros.com>, <joonas.viskari@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 0/2] x86: Add support for Atheros AR1520 GPS devices
Date: Fri, 6 May 2011 15:09:38 -0700
Message-ID: <1304719780-27347-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.7.4.15.g7811d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches adds support for the Atheros AR1520 GPS device,
currently only pegged onto an mrst platform. This creates a character
device called ar1520 and lets userspace talk to it through it. My only
concern against this approach is that it this requires a custom userspace
application for reseting the device, waking it up and for blocking reads
through ioctl. The character device can be used to read/write data to it
as well.

I'll try to get more information and details on the userspace application
and document stuff here:

http://wireless.kernel.org/en/users/Drivers/ar5120

In the meantime some review and testing would be appreciated as I modified
the original code a bit.

Allen Kao (2):
  misc: add Atheros ar1520 GPS support
  x86: add Atheros ar1520 platform support for mrst

 arch/x86/platform/mrst/mrst.c |   18 ++
 drivers/misc/Kconfig          |   10 +
 drivers/misc/Makefile         |    1 +
 drivers/misc/ar1520.c         |  406 +++++++++++++++++++++++++++++++++++++++++
 include/linux/ar1520.h        |   49 +++++
 5 files changed, 484 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/ar1520.c
 create mode 100644 include/linux/ar1520.h

-- 
1.7.4.15.g7811d

