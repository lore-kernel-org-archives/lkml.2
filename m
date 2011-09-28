Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab1I1X2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:28:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614Ab1I1Wjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:39:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:31 2011
Message-Id: <20110928220131.056611808@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [055/244] igb: fix WOL on second port of i350 device
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Carolyn Wyborny <carolyn.wyborny@intel.com>

commit 6d337dce664b6872ddf1655f6b1fcab76ce35b08 upstream.

This patch fixes a problem where WOL would fail on second port of i350
device.

Reported-by: Martin Wilck <martin.wilck@ts.fujitsu.com>
Reported-by: Stefan Assmann<sassmann@redhat.com>
Signed-off-by: Carolyn Wyborny <carolyn.wyborny@intel.com>
Tested-by:  Aaron Brown  <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/igb/igb_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -1985,7 +1985,7 @@ static int __devinit igb_probe(struct pc
 
 	if (hw->bus.func == 0)
 		hw->nvm.ops.read(hw, NVM_INIT_CONTROL3_PORT_A, 1, &eeprom_data);
-	else if (hw->mac.type == e1000_82580)
+	else if (hw->mac.type >= e1000_82580)
 		hw->nvm.ops.read(hw, NVM_INIT_CONTROL3_PORT_A +
 		                 NVM_82580_LAN_FUNC_OFFSET(hw->bus.func), 1,
 		                 &eeprom_data);


