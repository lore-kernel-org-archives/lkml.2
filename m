Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0FJFWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:22:32 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:40320 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab0FJFWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:22:31 -0400
Subject: [PATCH 0/2] Rework OF i2c support code
From: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, jeremy.kerr@canonical.com,
       devicetree-discuss@lists.ozlabs.org, ben-linux@fluff.org,
       linux-i2c@vger.kernel.org
Date: Wed, 09 Jun 2010 23:22:27 -0600
Message-ID: <20100610052102.16222.86662.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series reworks the of_i2c support code so that i2c drivers
can be matched to devices using the struct device_driver of_match table,
and so that i2c devices described in a device tree node will be
transparently registered if the i2c adapter of_node pointer is set.

The OF hooks used in the second patch are entirely compiled out when
CONFIG_OF is not set.

---

Ben, these changes probably should go through my devicetree branch.  They
are currently sitting in the following branch, and I'll move it over to
next-devicetree in a week or so if I don't receive any objections (it
can always come out again if there are, but I want the test coverage).

git://git.secretlab.ca/git/linux-2.6 test-devicetree

Grant Likely (2):
      of/i2c: Generalize OF support
      i2c: Add OF-style registration and binding


 drivers/i2c/busses/i2c-cpm.c     |    6 +----
 drivers/i2c/busses/i2c-ibm_iic.c |    4 +--
 drivers/i2c/busses/i2c-mpc.c     |    2 +-
 drivers/i2c/i2c-core.c           |    9 ++++++++
 drivers/of/Kconfig               |    2 +-
 drivers/of/of_i2c.c              |   44 ++++++++++++++++++++++++--------------
 include/linux/of_i2c.h           |   13 +++++++++--
 7 files changed, 51 insertions(+), 29 deletions(-)
