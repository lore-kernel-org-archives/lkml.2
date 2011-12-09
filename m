Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab1LISKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:10:49 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63939 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab1LISKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:10:47 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, dg77.kim@samsung.com, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, Jason.Wortham@maxim-ic.com,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH v2 0/6] MAX17042 add support for maxim POR procedure
Date: Fri,  9 Dec 2011 10:08:42 -0800
Message-Id: <1323454129-7444-1-git-send-email-dirk.brandewie@gmail.com>
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

Dirk Brandewie (5):
  max17042: Move power suppply registration to a worker thread
  max17042: Align register definitions with data sheet and init appnote
  max17042: Add POR init procedure from Maxim appnote
  max17042: Add support for signalling change in SOC
  x86-mrst: Add battery fuel guage platform data 

 arch/x86/platform/mrst/mrst.c          |   53 ++++
 drivers/power/max17042_battery.c       |  461 ++++++++++++++++++++++++++++++--
 include/linux/power/max17042_battery.h |   93 ++++++-
 3 files changed, 581 insertions(+), 26 deletions(-)

-- 
1.7.7.3

