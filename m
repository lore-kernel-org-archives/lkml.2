Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab1DPInS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 04:43:18 -0400
Received: from wnohang.net ([178.79.154.173]:51498 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab1DPInR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 04:43:17 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net A64ED34870
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 8594B3486D
Date: Sat, 16 Apr 2011 14:13:13 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] FIX: engine_state is uninitialized
Message-ID: <20110416084313.GA27564@Xye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20110416083730.GA5114@Xye>
X-Operating-System: Arch linux x86_64 2.6.38.2-bldit-db-FAE
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case lp5521_read() returns EIO, engine_state is in an uninitialized state. This
adds checks to fix that.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
  drivers/leds/leds-lp5521.c |   10 ++++++----
  1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index c0cff64..6c5eac0 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -176,11 +176,13 @@ static int lp5521_set_engine_mode(struct lp5521_engine *engine, u8 mode)
  
  	ret = lp5521_read(client, LP5521_REG_OP_MODE, &engine_state);
  
+	if (ret == 0){
  	/* set mode only for this engine */
-	engine_state &= ~(engine->engine_mask);
-	mode &= engine->engine_mask;
-	engine_state |= mode;
-	ret |= lp5521_write(client, LP5521_REG_OP_MODE, engine_state);
+		engine_state &= ~(engine->engine_mask);
+		mode &= engine->engine_mask;
+		engine_state |= mode;
+		ret |= lp5521_write(client, LP5521_REG_OP_MODE, engine_state);
+	}
  
  	return ret;
  }
-- 
1.7.4.4

--------------------------
Raghavendra Prabhu
GPG Id : D72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977

