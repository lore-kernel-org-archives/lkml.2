Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab2DPLUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 07:20:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38039 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab2DPLUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 07:20:34 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/2] Hyper-V disk support V3
Date: Mon, 16 Apr 2012 12:20:27 +0100
Message-Id: <1334575229-7493-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120414170223.24f6ea31@pyramind.ukuu.org.uk>
References: <20120414170223.24f6ea31@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for ignoring disks devices on specific host controllers to
libata.  Use this support to trigger us to ignore Hyper-V disk devices
on the emulated SATA device based on the system DMI information.

Jeff, I believe the first patch is what you had in mind in your comments.
Alan, the piix sadly has no subvendor/subdevice identifiers at all
though we are able to detect the platform from the DMI information,
this any better?

-apw

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


*** BLURB HERE ***

Andy Whitcroft (2):
  libata: add a host flag to ignore detected ATA devices
  UBUNTU: SAUCE: ata_piix: defer disks to the Hyper-V drivers by
    default

 drivers/ata/ata_piix.c    |   38 ++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-core.c |    6 ++++++
 include/linux/libata.h    |    1 +
 3 files changed, 45 insertions(+)

-- 
1.7.9.5

