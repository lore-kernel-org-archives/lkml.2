Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab1LCIVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 03:21:16 -0500
Received: from www17.your-server.de ([213.133.104.17]:60526 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1LCIU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 03:20:59 -0500
Subject: [PATCH] rt2x00: Use kcalloc instead of kzalloc to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: IvDoorn@gmail.com, gwingerde@gmail.com, helmut.schaa@googlemail.com,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        users@rt2x00.serialmonkey.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.325.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c 2011-11-28 19:36:47.770108588 +0100
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c 2011-11-28 19:54:53.495525543 +0100
@@ -831,11 +831,11 @@ static int rt2x00lib_probe_hw_modes(stru
 	if (spec->supported_rates & SUPPORT_RATE_OFDM)
 		num_rates += 8;
 
-	channels = kzalloc(sizeof(*channels) * spec->num_channels, GFP_KERNEL);
+	channels = kcalloc(spec->num_channels, sizeof(*channels), GFP_KERNEL);
 	if (!channels)
 		return -ENOMEM;
 
-	rates = kzalloc(sizeof(*rates) * num_rates, GFP_KERNEL);
+	rates = kcalloc(num_rates, sizeof(*rates), GFP_KERNEL);
 	if (!rates)
 		goto exit_free_channels;
 
