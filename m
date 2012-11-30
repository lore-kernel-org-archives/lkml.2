Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161062Ab2K3Sts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:49:48 -0500
Received: from mail.kernel.org ([198.145.19.201]:57598 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031706Ab2K3Stm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:49:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jussi Pakkanen <jussi.pakkanen@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, Dmitry Torokhov <dtor@mail.ru>,
        maximilian attems <max@stro.at>
Subject: [ 36/37] Input: bcm5974 - set BUTTONPAD property
Date: Fri, 30 Nov 2012 10:46:23 -0800
Message-Id: <20121130183901.118870985@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130183857.166228045@linuxfoundation.org>
References: <20121130183857.166228045@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jussi Pakkanen <jussi.pakkanen@canonical.com>

commit 52965cc012f7a3cf35f06485ec275ebf3b3fddae upstream.

Some bcm5974 trackpads have a physical button beneath the physical surface.
This patch sets the property bit so user space applications can detect the
trackpad type and act accordingly.

Signed-off-by: Jussi Pakkanen <jussi.pakkanen@canonical.com>
Reviewed-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/bcm5974.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -373,6 +373,9 @@ static void setup_events_to_report(struc
 	__set_bit(BTN_TOOL_QUADTAP, input_dev->keybit);
 	__set_bit(BTN_LEFT, input_dev->keybit);
 
+	if (cfg->caps & HAS_INTEGRATED_BUTTON)
+		__set_bit(INPUT_PROP_BUTTONPAD, input_dev->propbit);
+
 	input_set_events_per_packet(input_dev, 60);
 }
 


