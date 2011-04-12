Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab1DLJvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 05:51:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:5428 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956Ab1DLJvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 05:51:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,194,1301900400"; 
   d="scan'208";a="732218895"
Date: Tue, 12 Apr 2011 11:51:20 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Greg KH <gregkh@suse.de>
Subject: [GIT] [2.6.39] MFD fix
Message-ID: <20110412095119.GB14904@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is an MFD fix for 2.6.39.
The fix is for allowing MFD sub devices drivers to reach both their MFD cell
pointers and their platform data ones. We were previously doint that through
mfd_get_data(), but that could be troublesome for generic IP drivers being
used as both MFD sub devices drivers and generic platform drivers.
We fixed that by adding an MFD cell pointer to the platform_device structure,
and that will also allow us to get rid of the mfd_get_data() routine. I'll
leave that for the next merge window as it touches more than 20 drivers.
Greg and Grant reviewed this fix, and Greg ACKed it.

Thanks in advance for pulling this:

The following changes since commit a6360dd37e1a144ed11e6548371bade559a1e4df:

  Linux 2.6.39-rc3 (2011-04-11 17:21:51 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-linus

Samuel Ortiz (1):
      mfd: Fetch cell pointer from platform_device->mfd_cell

 drivers/base/platform.c         |    1 +
 drivers/mfd/mfd-core.c          |   16 ++++++++++++++--
 include/linux/mfd/core.h        |   13 +++++++++++--
 include/linux/platform_device.h |    5 +++++
 4 files changed, 31 insertions(+), 4 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
