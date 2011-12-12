Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1LLSmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:42:00 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37406 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1LLSl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:41:59 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, dg77.kim@samsung.com, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, Jason.Wortham@maxim-ic.com,
        bruce.e.robertson@intel.com, Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH v3 0/5] MAX17042 add support for maxim POR procedure
Date: Mon, 12 Dec 2011 10:39:28 -0800
Message-Id: <1323715173-26974-1-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch set adds support for the power on reset procedure for the
max17042 battery fuel gauge and alert interrupts.

The accuracy of the fuel gauge is improved by configuring the fuel
gauge with the characterization data for the battery present in the 
platform.

Changes since v2:

Dropped patch moving non-POR init to worker function.

Reorganized POR patch to only schedule worker thread if the fuel gauge
is in the POR state

Changes since v1:

Moved power_supply_register() back to the probe max17042_get_property() 
will return -EAGAIN until the init function completes

Added support for interrupts from the alert pin if the platform has it
connected to an interrupt source.

Added fix for the values returned by POWER_SUPPLY_PROP_VOLTAGE_NOW
and POWER_SUPPLY_PROP_VOLTAGE_AVG.

Added Ack's from previous patch series


Bruce Robertson (1):
  max17042: Fix value scaling for VCELL and avgVCELL

Dirk Brandewie (4):
  max17042: Align register definitions with data sheet and init appnote
  max17042: Add POR init procedure from Maxim appnote
  max17042: Add support for signalling change in SOC
  x86-mrst: Add battery fuel guage platform data

 arch/x86/platform/mrst/mrst.c          |   53 ++++
 drivers/power/max17042_battery.c       |  451 +++++++++++++++++++++++++++++++-
 include/linux/power/max17042_battery.h |   93 ++++++-
 3 files changed, 575 insertions(+), 22 deletions(-)

-- 
1.7.7.3

