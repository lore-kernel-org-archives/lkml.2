Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0ESPuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:50:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33257 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab0ESPuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:50:07 -0400
Date: Thu, 20 May 2010 01:50:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 10/17] wireless: update gfp/slab.h includes
Message-Id: <20100520015005.21089eb9.sfr@canb.auug.org.au>
In-Reply-To: <1269885165-18617-11-git-send-email-tj@kernel.org>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
	<1269885165-18617-11-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Tue, 30 Mar 2010 02:52:38 +0900 Tejun Heo <tj@kernel.org> wrote:
>
> Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> gfp.h or slab.h is included as necessary.

Please apply to the wireless tree (patch reposted below).

From: Tejun Heo <tj@kernel.org>
To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/17] wireless: update gfp/slab.h includes
Date: Tue, 30 Mar 2010 02:52:38 +0900

Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
gfp.h or slab.h is included as necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/htc.h       |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 7770649..4497479 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -23,6 +23,7 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/leds.h>
+#include <linux/slab.h>
 #include <net/mac80211.h>
 
 #include "common.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
index 4c5395e..0cc7fd9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/etherdevice.h>
 #include <linux/sched.h>
+#include <linux/gfp.h>
 #include <net/mac80211.h>
 
 #include "iwl-dev.h"
-- 
1.6.4.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
