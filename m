Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab2LCOol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:44:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43882 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755448Ab2LCOgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:51 -0500
Message-Id: <20121203143153.956756838@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:32 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jussi Pakkanen <jussi.pakkanen@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, Dmitry Torokhov <dtor@mail.ru>
Subject: [ 46/89] Input: bcm5974 - set BUTTONPAD property
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jussi Pakkanen <jussi.pakkanen@canonical.com>

commit 52965cc012f7a3cf35f06485ec275ebf3b3fddae upstream.

Some bcm5974 trackpads have a physical button beneath the physical surface.
This patch sets the property bit so user space applications can detect the
trackpad type and act accordingly.

Signed-off-by: Jussi Pakkanen <jussi.pakkanen@canonical.com>
Reviewed-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/mouse/bcm5974.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 5ec617e..913e9fa 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -433,6 +433,9 @@ static void setup_events_to_report(struct input_dev *input_dev,
 	__set_bit(BTN_TOOL_QUADTAP, input_dev->keybit);
 	__set_bit(BTN_LEFT, input_dev->keybit);
 
+	if (cfg->caps & HAS_INTEGRATED_BUTTON)
+		__set_bit(INPUT_PROP_BUTTONPAD, input_dev->propbit);
+
 	input_set_events_per_packet(input_dev, 60);
 }
 


