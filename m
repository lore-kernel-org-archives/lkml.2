Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab2KZOkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 09:40:06 -0500
Received: from mga07.intel.com ([143.182.124.22]:41744 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752996Ab2KZOkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 09:40:02 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        dm-devel@redhat.com, linux-crypto@vger.kernel.org
Subject: [PATCHv2 0/1] dm-integrity: integrity protection device-mapper target
Date: Mon, 26 Nov 2012 16:39:51 +0200
Message-Id: <cover.1353940203.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device-mapper "integrity" target provides transparent cryptographic integrity
protection of underlying read-write block device using hash-based message
authentication codes (HMACs), which can be stored on the same or different
block device.

Target uses kernel keyring to obtain a secret key for using in cryptographic
operations. It uses encrypted key type. Kernel never exposes those keys in
plain form to user space. Encrypted keys are encrypted using master key,
which can be either user or trusted type. User key type allows to supply a key
from the user space and trusted key uses TPM.

Secret key is usually device specific and binds integrity data to the device.
Data blocks and corresponding HMACs cannot be copied over from other systems.

The key advantage over dm-verity is that the target supports read-write and
requires less hash calculation operations, but it cannot be used to build a
a file system image to be used on multiple devices unless secret key is the
same across all device. The main purpose is to provide read-write capable
local block data integrity protection.

Changes in v2:
- added block size parameter
- added hmac algo parameter
- fixed table output
- added sync mode flag to handle reboot notifications
- added discards handling
- use DM functions for printing kernel messages

- Dmitry

Dmitry Kasatkin (1):
  dm-integrity: integrity protection device-mapper target

 Documentation/device-mapper/dm-integrity.txt |  137 ++++
 drivers/md/Kconfig                           |   13 +
 drivers/md/Makefile                          |    1 +
 drivers/md/dm-integrity.c                    | 1050 ++++++++++++++++++++++++++
 4 files changed, 1201 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-integrity.txt
 create mode 100644 drivers/md/dm-integrity.c

-- 
1.7.10.4

