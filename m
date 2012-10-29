Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab2J2JKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:10:37 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42682 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259Ab2J2JKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:10:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, Huang Ying <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 0/7] ACPI / PM: ACPI power management callback routines for subsystems
Date: Mon, 29 Oct 2012 10:06:32 +0100
Message-ID: <1766582.8gdQKXoi0K@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The following series of patches rearranges ACPI device power management
code and introduces universal PM callback routines that may be used by
bus types that don't support power management natively and/or by drivers
of devices with those bus types.

[1/7] Move routines for adding/removing device wakeup notifiers into a separate
      file.
[2/7] Move device power state selection routine to the new device PM file.
[3/7] Move runtime remote wakeup setup routine to the new device PM file.
[4/7] Split device wakeup management routines, so that it is possible to
      reduce the number of acpi_bus_get_device() calls.
[5/7] Provide low-lever device PM functions operationg on struct acpi_device
      objects.
[6/7] Move device PM functions related to sleep states from sleep.c to the
      new device PM file.
[7/7] Provide ACPI PM callback routines for subsystems.

The patches are on top of the current Linus' tree with the git branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-qos

merged.  The resulting kernel has been run on my test-bed Toshiba Portege R500
and hasn't crashed it, but more testing is still needed, so please use it with
care.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
