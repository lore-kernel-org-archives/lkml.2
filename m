Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab2BTUJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 15:09:47 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33447 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2BTUJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 15:09:46 -0500
From: Brian Norris <computersforpeace@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kevin Cernekee <cernekee@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, Norbert Preining <preining@logic.at>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        "Rafael J . Wysocki" <rjw@sisk.pl>
Subject: [PATCH 0/3] ahci: fix boot/resume COMRESET failures
Date: Mon, 20 Feb 2012 12:09:20 -0800
Message-Id: <1329768563-13715-1-git-send-email-computersforpeace@gmail.com>
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

Brian Norris (3):
  ahci: add AHCI_HFLAG_STRICT_SPEC host flag
  ahci: move AHCI_HFLAGS() macro to ahci.h
  ahci_platform: add STRICT_AHCI platform type

 drivers/ata/ahci.c          |    2 --
 drivers/ata/ahci.h          |    4 ++++
 drivers/ata/ahci_platform.c |   11 +++++++++++
 drivers/ata/libahci.c       |    5 +++++
 4 files changed, 20 insertions(+), 2 deletions(-)

