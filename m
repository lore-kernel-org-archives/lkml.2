Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab0FNLuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 07:50:06 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:49705 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752369Ab0FNLuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 07:50:03 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] hid-input: Use a larger event buffer for MT devices
Date: Mon, 14 Jun 2010 13:49:41 +0200
Message-Id: <1276516181-4519-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OO8Al-0001qG-9E.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OO8Al-0001qG-9E ea2bc5a7b96ab9109ae8aa475559eb87
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MT devices produce a lot of data. Tell the underlying input device
approximately how many events will be sent per synchronization, to allow
for better buffering. The number is a template based on continuously
reporting details for each finger on a single hand.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Jiri,

This patch goes together with the evdev buffer patchset, which Dmitry
is going to queue for 2.6.36.

Cheers,
Henrik

 drivers/hid/hid-input.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 7a0d2e4..69d152e 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -534,6 +534,9 @@ mapped:
 			input_set_abs_params(input, usage->code, a, b, (b - a) >> 8, (b - a) >> 4);
 		else	input_set_abs_params(input, usage->code, a, b, 0, 0);
 
+		/* use a larger default input buffer for MT devices */
+		if (usage->code == ABS_MT_POSITION_X && input->hint_events_per_packet == 0)
+			input_set_events_per_packet(input, 60);
 	}
 
 	if (usage->type == EV_ABS &&
-- 
1.6.3.3

