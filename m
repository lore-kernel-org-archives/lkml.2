Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab2BVKQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 05:16:07 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34833 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab2BVKQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 05:16:05 -0500
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, amit.kachhap@linaro.org,
        durgadoss.r@intel.com, rob.lee@linaro.org, patches@linaro.org
Subject: [PATCH 0/4] thermal: Adding generic cpu cooling devices
Date: Wed, 22 Feb 2012 15:44:06 +0530
Message-Id: <1329905650-30161-1-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since RFC:
 *Changed the cpu cooling registration/unregistration API's to instance based
 *Changed the STATE_ACTIVE trip type to pass correct instance id
 *Adding support to restore back the policy->max_freq after doing frequency 
  clipping.
 *Moved the trip cooling stats from sysfs node to debugfs node as suggested
  by Greg KH greg@kroah.com 
 *Incorporated several review comments from eduardo.valentin@ti.com

Todo:
 *Report time spent in each trip point along with the cooling statistics
 *Add opp library support in cpufreq cooling api's

Brief Description:

1) The generic cooling devices code is placed inside driver/thermal/* as 
placing inside acpi folder will need un-necessary enabling of acpi code.

2) This patchset adds a new trip type THERMAL_TRIP_STATE_ACTIVE which passes
cooling device instance number and may be helpful for cpufreq cooling devices
to take the correct cooling action.

3) This patchset adds generic cpu cooling low level implementation through
frequency clipping and cpu hotplug. In future, other cpu related cooling
devices may be added here. An ACPI version of this already exists
(drivers/acpi/processor_thermal.c). But this will be useful for platforms
like ARM using the generic thermal interface along with the generic cpu
cooling devices. The cooling device registration API's return cooling device
pointers which can be easily binded with the thermal zone trip points.

4)This patchset provides a simple way of reporting cooling achieved in a
trip type. This will help in fine cooling the cooling devices attached.

Amit Daniel Kachhap (4):
  thermal: Add a new trip type to use cooling device instance number
  thermal: Add generic cpufreq cooling implementation
  thermal: Add generic cpuhotplug cooling implementation
  thermal: Add support to report cooling statistics achieved by cooling
    devices

 Documentation/thermal/cpu-cooling-api.txt |   57 ++++
 Documentation/thermal/sysfs-api.txt       |    4 +-
 drivers/thermal/Kconfig                   |   11 +
 drivers/thermal/Makefile                  |    1 +
 drivers/thermal/cpu_cooling.c             |  484 +++++++++++++++++++++++++++++
 drivers/thermal/thermal_sys.c             |  165 ++++++++++-
 include/linux/cpu_cooling.h               |   71 +++++
 include/linux/thermal.h                   |   14 +
 8 files changed, 802 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/thermal/cpu-cooling-api.txt
 create mode 100644 drivers/thermal/cpu_cooling.c
 create mode 100644 include/linux/cpu_cooling.h

