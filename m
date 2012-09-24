Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab2IXJzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:55:18 -0400
Received: from mga06.intel.com ([134.134.136.21]:6866 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752157Ab2IXJzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:55:16 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        dm-devel@redhat.com, linux-crypto@vger.kernel.org
Subject: [PATCH 0/1] dm-integrity: integrity protection device-mapper target
Date: Mon, 24 Sep 2012 12:55:06 +0300
Message-Id: <cover.1348480396.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two existing offline integrity models: file level integrity
(linux-integrity subsystem EVM/IMA-appraisal) and block level integrity
(dm-verity, dm-crypt).

This patch provides a new block level method called device-mapper "integrity"
target (dm-integrity), which provides transparent cryptographic integrity
protection of the underlying read-write block device using hash-based message
authentication codes (HMACs). The HMACs can be stored on the same or different
block device.

dm-integrity uses an encrypted key type, stored on the kernel keyring, to
obtain a secret key for use in cryptographic operations. Encrypted keys are
never exposed in plain text to user space. The encrypted keys are encrypted
using master key, which can either be a user defined or trusted key type.
The secret key, which is usually device specific, binds integrity data to the
device. As a result data blocks and corresponding HMACs cannot simply be
copied over from other file systems.

EVM/IMA-appraisal provides file level integrity protection. The advantages
are that it is policy based, file measurements are available for remote
attestation, and files can be digitally signed to provide authenticity.

Both dm-verity and dm-crypt provide block level integrity protection.
dm-verity provides block level integrity protection for read-only file
systems, while dm-crypt provides block level integrity protection, with
minimum penalty, for filesystems requiring full disk encryption.

dm-integrity provides a lighter weight read-write block level integrity
protection for file systems not requiring full disk encryption, but
which do require writability.

- Dmitry

Dmitry Kasatkin (1):
  dm-integrity: integrity protection device-mapper target

 Documentation/device-mapper/dm-integrity.txt |  125 ++++
 drivers/md/Kconfig                           |   12 +
 drivers/md/Makefile                          |    1 +
 drivers/md/dm-integrity.c                    | 1019 ++++++++++++++++++++++++++
 4 files changed, 1157 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-integrity.txt
 create mode 100644 drivers/md/dm-integrity.c

-- 
1.7.9.5

