Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab0JIWej (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 18:34:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35804 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab0JIWei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 18:34:38 -0400
From: James Hogan <james@albanarts.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 0/2] pm_trace: Add locking and add sysfs attr for rechecking dev hash.
Date: Sat, 9 Oct 2010 23:34:27 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-custom+; KDE/4.4.5; x86_64; ; )
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <rdunlap@xenotime.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        markgross <markgross@thegnar.org>
MIME-Version: 1.0
X-Length: 2145
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010092334.27808.james@albanarts.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A fix and an improvement to the pm_trace code.

The improvement allows finding out via sysfs which device was last traced when 
the device is part of a kernel module (which means it doesn't get printed on 
next boot since it isn't loaded yet).

Unsure as always about what to name stuff, so comments most welcome.

James Hogan (2):
  pm_trace: Lock pm device list mutex.
  pm_trace: Add sysfs attr for rechecking dev hash.

 Documentation/power/s2ram.txt |    7 +++++++
 drivers/base/power/trace.c    |   32 +++++++++++++++++++++++++++++++-
 include/linux/resume-trace.h  |    2 ++
 kernel/power/main.c           |   18 ++++++++++++++++++
 4 files changed, 58 insertions(+), 1 deletions(-)

-- 
1.7.2.3
