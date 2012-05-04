Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180Ab2EDVP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:15:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33143 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760031Ab2EDVPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:15:15 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/2] Hyper-V disk support V5
Date: Fri,  4 May 2012 22:15:09 +0100
Message-Id: <1336166111-20483-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <4F903529.40800@mvista.com>
References: <4F903529.40800@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for ignoring disks devices on specific host controllers to
libata.  Use this support to trigger us to ignore Hyper-V disk devices
on the emulated SATA device based on the system DMI information.

Fixes based on feedback Sergei Shtylyov, thanks.  Jeff I think this is
about done, any objections to merging?

Comments?

-apw

V5
  - switched to IS_ENABLED
  - fixed device type in device ignored messages

V4
  - only enable the quirk when the paravirtualised drivers are compiled
  - fix up the command line flag to disable this support

V3
  - switch detection method to DMI information

V2 
  - create a generic libata quirk
  - switch detection to piix_init_one

Andy Whitcroft (2):
  libata: add a host flag to ignore detected ATA devices
  ata_piix: defer disks to the Hyper-V drivers by default

 drivers/ata/ata_piix.c    |   20 ++++++++++++++++++++
 drivers/ata/libata-core.c |    7 +++++++
 include/linux/libata.h    |    1 +
 3 files changed, 28 insertions(+)

-- 
1.7.9.5

Andy Whitcroft (2):
  libata: add a host flag to ignore detected ATA devices
  ata_piix: defer disks to the Hyper-V drivers by default

 drivers/ata/ata_piix.c    |   36 ++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-core.c |    6 ++++++
 include/linux/libata.h    |    1 +
 3 files changed, 43 insertions(+)

-- 
1.7.9.5

