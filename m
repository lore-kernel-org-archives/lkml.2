Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1KQKOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 05:14:23 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36004 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471Ab1KQKNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 05:13:54 -0500
X-AuditID: cbfee61b-b7b7fae000005864-85-4ec4de5eea0e
From: Donggeun Kim <dg77.kim@samsung.com>
To: linux-pm@vger.kernel.org
Cc: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, rdunlap@xenotime.net,
        cbouatmailru@gmail.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] power: introduce Charger-Manager
Date: Thu, 17 Nov 2011 19:13:11 +0900
Message-id: <1321524793-25117-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Charger Manager provides in-kernel battery charger management that
requires temperature monitoring during both normal and suspend-to-RAM states
and where each battery may have multiple chargers attached and the userland
wants to look at the aggregated information of the multiple chargers.

Charger Manager is a platform_driver with power-supply-class entries.
An instance of Charger Manager (a platform-device created with
Charger-Manager) represents a battery with chargers. If there are multiple
batteries with their own chargers acting independently in a system,
the system may need multiple instances of Charger Manager.
Multiple chargers (e.g., USB, wireless, and solar panels) may be included
as pairs of a regulator and a power-supply-class
per charger.

Charger Manager glues multiple charger-related frameworks (regulators of
chargers, power-supply-class from chargers and fuel-gauge, RTC,
suspend-again, ...) together to provide aggregated information and
transparent battery monitoring to userspace.

For the discussions about the need for in-suspend monitoring, please
refer to the discussions of suspend-again in PM:
v1 https://lists.linux-foundation.org/pipermail/linux-pm/2011-April/031052.html
v2 https://lists.linux-foundation.org/pipermail/linux-pm/2011-April/031111.html
v3 https://lists.linux-foundation.org/pipermail/linux-pm/2011-May/031267.html
v4 https://lists.linux-foundation.org/pipermail/linux-pm/2011-May/031357.html
v5 (last, applied) https://lists.linux-foundation.org/pipermail/linux-pm/2011-June/031561.html

To see the usage example, please refer to:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/charger-manager
In this git branch, a test code for Exynos4-NURI is shown.

This patch set supports initial Charger Manager driver.

Donggeun Kim (2):
  power: Charger-Manager: add initial Charger-Manager driver
  power: Charger-Manager: add properties for power-supply-class

 Documentation/power/charger-manager.txt |  164 +++++
 drivers/power/Kconfig                   |    9 +
 drivers/power/Makefile                  |    1 +
 drivers/power/charger-manager.c         | 1064 +++++++++++++++++++++++++++++++
 include/linux/power/charger-manager.h   |  148 +++++
 5 files changed, 1386 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/power/charger-manager.txt
 create mode 100644 drivers/power/charger-manager.c
 create mode 100644 include/linux/power/charger-manager.h

-- 
1.7.4.1

