Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304Ab0G3SiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:38:08 -0400
Received: from kroah.org ([198.145.64.141]:57950 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759771Ab0G3Ryf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:35 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:36 2010
Message-Id: <20100730175136.299426829@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike McCormack <mikem@ring3k.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [030/205] sky2: Restore multicast after restart
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike McCormack <mikem@ring3k.org>

commit 37652522faa0877dc6d0dbb6b999bdccc07f0e89 upstream.

Multicast settings will be lost on reset, so restore them.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sky2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -3293,6 +3293,7 @@ static void sky2_restart(struct work_str
 			continue;
 
 		sky2_hw_up(sky2);
+		sky2_set_multicast(dev);
 		netif_wake_queue(dev);
 	}
 


