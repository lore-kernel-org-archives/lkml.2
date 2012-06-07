Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310Ab2FGSlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 14:41:08 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48775 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab2FGSlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 14:41:06 -0400
Message-ID: <1339094567.21398.2.camel@key-ThinkPad-W510>
Subject: [PATCH 0/2] Move the tpm_get_random api and add an hwrng driver for
 it
From: Kent Yoder <key@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: tpmdd-devel@lists.sourceforge.net, m.selhorst@sirrix.com,
        safford@us.ibm.com, key@linux.vnet.ibm.com
Date: Thu, 07 Jun 2012 13:42:47 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060718-9360-0000-0000-000007204987
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches move the tpm_get_random API out of the trusted keys code
and into the tpm device driver itself.  Then a hwrng driver is added that
makes use of the API to provide a H/W RNG source.

  These are based off the latest upstream kernel.

Thanks,
Kent

Kent Yoder (2):
  tpm: Move tpm_get_random api into the TPM device driver
  hw_random: add support for the TPM chip as a hardware RNG source

 drivers/char/hw_random/Kconfig   |   13 +++++++++
 drivers/char/hw_random/Makefile  |    1 +
 drivers/char/hw_random/tpm-rng.c |   55 ++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm.c           |   53 ++++++++++++++++++++++++++++++++----
 drivers/char/tpm/tpm.h           |   23 ++++++++++++++++
 include/linux/tpm.h              |    4 +++
 security/keys/trusted.c          |   47 +++++++-------------------------
 7 files changed, 153 insertions(+), 43 deletions(-)
 create mode 100644 drivers/char/hw_random/tpm-rng.c

-- 
1.7.5.4


