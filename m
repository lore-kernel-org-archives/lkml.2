Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab1H0O7n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:59:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab1H0O7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:59:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:56 2011
Message-Id: <20110826215056.396701567@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [34/35] igb: Fix lack of flush after register write and before delay
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Carolyn Wyborny <carolyn.wyborny@intel.com>

commit 064b43304ed8ede8e13ff7b4338d09fd37bcffb1 upstream.

Register writes followed by a delay are required to have a flush
before the delay in order to commit the values to the register.  Without
the flush, the code following the delay may not function correctly.

Reported-by: Tong Ho <tong.ho@ericsson.com>
Reported-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Carolyn Wyborny <carolyn.wyborny@intel.com>
Tested-by:  Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/igb/e1000_82575.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/igb/e1000_82575.c
+++ b/drivers/net/igb/e1000_82575.c
@@ -1735,6 +1735,7 @@ static s32 igb_reset_hw_82580(struct e10
 		ctrl |= E1000_CTRL_RST;
 
 	wr32(E1000_CTRL, ctrl);
+	wrfl();
 
 	/* Add delay to insure DEV_RST has time to complete */
 	if (global_device_reset)


