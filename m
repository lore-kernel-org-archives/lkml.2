Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab0JJBCJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 21:02:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47367 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab0JJBCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 21:02:07 -0400
From: James Hogan <james@albanarts.com>
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: [PATCH v2 0/2] pm_trace: Add locking and add sysfs attr for rechecking dev hash.
Date: Sun, 10 Oct 2010 02:02:00 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-custom+; KDE/4.4.5; x86_64; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        markgross <markgross@thegnar.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Greg Kroah-Hartman" <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010100202.01605.james@albanarts.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A fix and an improvement to the pm_trace code.

The improvement allows finding out via sysfs which device was last traced when
the device is part of a kernel module (which means it doesn't get printed on
next boot since it isn't loaded yet).

Changes in v2:
- renamed sysfs attr pm_trace_dev_hash to pm_trace_dev_match
- renamed snprint_trace_dev_hash to show_trace_dev_match
- added comment in show_trace_dev_match referring to the fact that multiple
  devices could match the hash and they all need printing out
- added documentation to Documentation/ABI/testing/sysfs-power
- minor rewording in Documentation/power/s2ram.txt

James Hogan (2):
  pm_trace: Lock pm device list mutex.
  pm_trace: Add sysfs attr for rechecking dev hash.

 Documentation/ABI/testing/sysfs-power |   29 ++++++++++++++++++++++++++
 Documentation/power/s2ram.txt         |    7 ++++++
 drivers/base/power/trace.c            |   36 ++++++++++++++++++++++++++++++++-
 include/linux/resume-trace.h          |    2 +
 kernel/power/main.c                   |   18 ++++++++++++++++
 5 files changed, 91 insertions(+), 1 deletions(-)

-- 
1.7.2.3
