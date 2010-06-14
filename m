Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0FNIZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 04:25:50 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:54236 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023Ab0FNIZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 04:25:48 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: bcm5974: Set the average number of events per MT event packet
Date: Mon, 14 Jun 2010 10:25:16 +0200
Message-Id: <1276503916-5013-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OO4yw-0003e6-CD.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OO4yw-0003e6-CD 93c121459a8924a111535d274e1bca49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MT devices produce a lot of data. Tell the underlying input device
approximately how many events will be sent per synchronization, to allow
for better buffering. The number is a template based on continuously
reporting details for each finger on a single hand.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/bcm5974.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 6dedded..84094bb 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -312,6 +312,8 @@ static void setup_events_to_report(struct input_dev *input_dev,
 	__set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
 	__set_bit(BTN_TOOL_QUADTAP, input_dev->keybit);
 	__set_bit(BTN_LEFT, input_dev->keybit);
+
+	input_set_events_per_packet(input_dev, 60);
 }
 
 /* report button data as logical button state */
-- 
1.6.3.3

