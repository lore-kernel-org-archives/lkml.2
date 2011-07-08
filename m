Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1GHFB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:01:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab1GHFBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:01:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:55 2011
Message-Id: <20110708001655.005307064@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <khali@linux-fr.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: [023/107] Revert "drm/i915: Enable GMBUS for post-gen2 chipsets"
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 826c7e4147f902737b281e8a5a7d7aa33fd63316 upstream.

Revert commit 8f9a3f9b63b8cd3f03be9dc53533f90bd4120e5f. This fixes a
hang when loading the eeprom driver (see bug #35572.) GMBUS will be
re-enabled later, differently.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Reported-by: Marek Otahal <markotahal@gmail.com>
Tested-by: Yermandu Patapitafious <yermandu.dev@gmail.com>
Tested-by: Andrew Lutomirski <luto@mit.edu>
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_i2c.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -401,8 +401,7 @@ int intel_setup_gmbus(struct drm_device
 		bus->reg0 = i | GMBUS_RATE_100KHZ;
 
 		/* XXX force bit banging until GMBUS is fully debugged */
-		if (IS_GEN2(dev))
-			bus->force_bit = intel_gpio_create(dev_priv, i);
+		bus->force_bit = intel_gpio_create(dev_priv, i);
 	}
 
 	intel_i2c_reset(dev_priv->dev);


