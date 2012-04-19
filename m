Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab2DSOdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 10:33:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55351 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab2DSOdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 10:33:14 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/2] Hyper-V disk support V4
Date: Thu, 19 Apr 2012 15:33:08 +0100
Message-Id: <1334845990-13418-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120419074018.GA3342@shadowen.org>
References: <20120419074018.GA3342@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for ignoring disks devices on specific host controllers to
libata.  Use this support to trigger us to ignore Hyper-V disk devices
on the emulated SATA device based on the system DMI information.

I have cleaned up the Hyper-V detection so it is only included when the
paravirtualised drivers are enabled.  I have also reintroduced the
override which had mysteriously gone missing in V3.

Comments?

-apw

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
