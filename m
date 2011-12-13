Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1LMPNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:13:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62240 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab1LMPNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:13:34 -0500
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rui.zhang@intel.com,
        linaro-dev@lists.linaro.org, amit.kachhap@linaro.org,
        patches@linaro.org
Subject: [RFC PATCH 0/2] thermal: Add generic cpu cooling devices according to thermal framework
Date: Tue, 13 Dec 2011 20:43:14 +0530
Message-Id: <1323789196-4942-1-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PATCH 1)  [thermal: Add a new trip type to use cooling device instance number]
This patch adds a new trip type THERMAL_TRIP_STATE_ACTIVE which passes
cooling device instance number and may be helpful for cpufreq cooling devices
to take the correct cooling action.

PATCH 2)  [thermal: Add generic cpu cooling implementation]
This patch adds generic cpu cooling low level implementation through frequency
clipping and cpu hotplug. In future, other cpu related cooling devices may be
added here. An ACPI version of this already exists(drivers/acpi/processor_thermal.c).
But this will be useful for platforms like ARM using the generic thermal interface
along with the generic cpu cooling devices. The cooling device registration API's
return cooling device pointers which can be easily binded with the thermal zone
trip points.


Amit Daniel Kachhap (2):
  thermal: Add a new trip type to use cooling device instance number
  thermal: Add generic cpu cooling implementation

 Documentation/thermal/cpu-cooling-api.txt |   52 +++++
 Documentation/thermal/sysfs-api.txt       |    4 +-
 drivers/thermal/Kconfig                   |   11 +
 drivers/thermal/Makefile                  |    1 +
 drivers/thermal/cpu_cooling.c             |  302 +++++++++++++++++++++++++++++
 drivers/thermal/thermal_sys.c             |   27 +++-
 include/linux/cpu_cooling.h               |   45 +++++
 include/linux/thermal.h                   |    1 +
 8 files changed, 440 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/thermal/cpu-cooling-api.txt
 create mode 100644 drivers/thermal/cpu_cooling.c
 create mode 100644 include/linux/cpu_cooling.h

