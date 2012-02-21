Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab2BUSii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:38:38 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42881 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2BUSif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:38:35 -0500
From: Brian Norris <computersforpeace@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Brian Norris <computersforpeace@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, Norbert Preining <preining@logic.at>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        "Rafael J . Wysocki" <rjw@sisk.pl>
Subject: [PATCH v2 0/3] ahci: fix boot/resume COMRESET failures
Date: Tue, 21 Feb 2012 10:38:41 -0800
Message-Id: <1329849524-23758-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.7.5.4.2.g519b1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series addresses regression problems with

    commit 7faa33da9b7add01db9f1ad92c6a5d9145e940a7
    ahci: start engine only during soft/hard resets

Because the fix provided by the above commit caused COMRESET failures and
10 second boot-time/resume-time hangs for certain DVD drives, we need to
make the fix conditional to certain devices/platforms. Add a flag for this.

Brian

v2: change flag name to AHCI_HFLAG_DELAY_ENGINE, write more detailed
    comments

v1: flag named AHCI_HFLAG_STRICT_SPEC

Brian Norris (3):
  ahci: add AHCI_HFLAG_DELAY_ENGINE host flag
  ahci: move AHCI_HFLAGS() macro to ahci.h
  ahci_platform: add STRICT_AHCI platform type

 drivers/ata/ahci.c          |    2 --
 drivers/ata/ahci.h          |    6 ++++++
 drivers/ata/ahci_platform.c |   11 +++++++++++
 drivers/ata/libahci.c       |    5 +++++
 4 files changed, 22 insertions(+), 2 deletions(-)

