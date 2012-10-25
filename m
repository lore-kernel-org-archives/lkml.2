Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935963Ab2JYQ52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:57:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54461 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933975Ab2JYQ50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:57:26 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: <linux-ide@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: [RFC 0/3] libata/ahci unbinding, power down sequence
Date: Thu, 25 Oct 2012 09:55:58 -0700
Message-Id: <1351184161-31433-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I sent out a few questions/suggestions earlier, regarding some trouble I was
having in supporting my SoC SATA controller under the libata / ahci_platform
driver:

    http://article.gmane.org/gmane.linux.ide/52951/match=unbind+rmmod

I think I have identified a problem in libata's handling of hardware activity
at device removal/exit (relevant to my use-case of unbind or rmmod). This patch series:

(1) Allows ahci_platform to unbind a device from the driver. This is useful for
    allowing total power-off of the device, for instance.
(2) Modifies libata-core so that ata_host_stop() is not called as a devres
    cleanup function (after all driver-specific functions, including power-off)

The first two patches are relatively harmless and correct, I believe, where the
third patch is more significant and could use good review. I am sending code
because I hear no response to my standalone suggestions :) Please see my
previous email (URL above) and/or patch 3/3 for a more detailed description.

Thanks,
Brian

Brian Norris (3):
  ahci_platform: enable hotplug unbinding
  ahci_platform: convert to module_platform_driver
  libata: don't perform HW activity in devres

 drivers/ata/ahci_platform.c | 16 +++-------------
 drivers/ata/libata-core.c   | 18 +++---------------
 2 files changed, 6 insertions(+), 28 deletions(-)

-- 
1.7.11.3

