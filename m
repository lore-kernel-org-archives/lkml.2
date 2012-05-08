Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab2EHVlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 17:41:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab2EHVlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 17:41:14 -0400
From: NeilBrown <neilb@suse.de>
To: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Date: Wed, 09 May 2012 07:40:39 +1000
Subject: [PATCH 0/4] twl4030_charger improvements.
Cc: Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Message-ID: <20120508213518.2844.95446.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 this series is a resend of a previous submission with some
 contentious patches removed and extra maintainers added.

 They allow the twl4030 to charge the backup battery (voltage and
 current configured in board file) and allow the charger to continue
 charging while the USB PHY is otherwise idle (no gadget module
 loaded, or host in suspend-to-RAM).

 Anton: could you take the first three?  Do I need to split the third
   patch into an 'MFD' part for Samuel and a power_supply part for you?

 Felipe: could you take the usb/otg patch?  It can be applied quite
   independently of the others, but won't be effective until they are
   also present.

Thanks,
NeilBrown

---

NeilBrown (4):
      usb: otg: twl4030-usb: Don't power down phy when it is in-use by charger.
      power_supply/MFD: twl4030_charger: Allow charger to control the regulator that feeds it.
      power_supply: twl4030_charger: add backup-battery charging.
      power_supply: twl4030_charger: Fix some typos


 drivers/mfd/twl-core.c          |    9 ++--
 drivers/power/twl4030_charger.c |   80 ++++++++++++++++++++++++++++++++++++++-
 drivers/usb/otg/twl4030-usb.c   |    8 +++-
 include/linux/i2c/twl.h         |    2 +
 4 files changed, 91 insertions(+), 8 deletions(-)

-- 
Signature

