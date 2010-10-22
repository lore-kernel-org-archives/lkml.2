Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab0JVTWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:22:10 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:25037 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759230Ab0JVTU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:20:58 -0400
Subject: [PATCH 0/5] cciss updates, PCI ID changes, kdump reset fixes 
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, smcameron@yahoo.com,
        linux-kernel@vger.kernel.org, mike.miller@hp.com, thenzl@redhat.com
Date: Fri, 22 Oct 2010 14:20:56 -0500
Message-ID: <20101022191738.25567.43468.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements fixes in the board resetting code
invoked by the reset_devices kernel parameter, typically used
by kdump kernels.

Also removes support for some controllers which are also supported
by hpsa.  We do not wish to have any overlap between the two drivers.

Also change one small msleep to use usleep_range.

---

Stephen M. Cameron (5):
      cciss: remove controllers supported by hpsa
      cciss: fix board status waiting code
      cciss: Use kernel provided PCI state save and restore functions
      cciss: limit commands allocated on reset_devices
      cciss: use usleep_range not msleep for small sleeps


 drivers/block/cciss.c |  169 +++++++++++++++++--------------------------------
 drivers/block/cciss.h |    4 +
 2 files changed, 64 insertions(+), 109 deletions(-)

-- 
-- steve
