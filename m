Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0CRR73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:59:29 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:36897 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab0CRR71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:59:27 -0400
Subject: [PATCH v2 0/4] hpet: convert from ACPI to PNP driver
To: Clemens Ladisch <clemens@ladisch.de>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Venkatesh Pallipadi <venki@google.com>, Vojtech Pavlik <vojtech@suse.cz>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Thu, 18 Mar 2010 11:59:25 -0600
Message-ID: <20100318175852.15143.2124.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HPET driver parses ACPI _CRS data manually, but PNPACPI already does
that, and it does a more complete job, so we can simplify the HPET driver
quite a bit by taking advantage of that.

Clemens, if you like these, will you take care of merging them, or do
I need to shepherd them through some other path?

Changes from v1 to v2:
    - Wrap PNP code in "#ifdef CONFIG_PNP" (Venki)
    - Fix leak when hpet_alloc() fails (Venki)

---

Bjorn Helgaas (4):
      hpet: convert from ACPI to PNP driver
      hpet: pass physical address, not entire hpet_data, to hpet_is_known()
      hpet: clean up io mapping when hpet_alloc() fails
      MAINTAINERS: remove obsolete HPET ACPI entry


 MAINTAINERS         |    5 --
 drivers/char/hpet.c |  119 ++++++++++++++++-----------------------------------
 2 files changed, 38 insertions(+), 86 deletions(-)
