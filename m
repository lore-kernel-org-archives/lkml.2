Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1BPBS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:18:27 -0500
Received: from kroah.org ([198.145.64.141]:45329 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932903Ab1BPAsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:48:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:03 2011
Message-Id: <20110216002103.042290566@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        =?ISO-8859-15?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>
Subject: [patch 039/176] staging: hv: fix netvsc sleeping while atomic
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>

commit d70c673153d42e8aefd5ac296c8159ef222d076b upstream.

The channel callbacks are called directly from vmbus_event_dpc
which runs in tasklet context. These callbacks need to use
GFP_ATOMIC.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=16701

Cc: Hank Janssen <hjanssen@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Timo Teräs <timo.teras@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/netvsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -1250,7 +1250,7 @@ static void NetVscOnChannelCallback(void
 	/* ASSERT(device); */
 
 	packet = kzalloc(NETVSC_PACKET_SIZE * sizeof(unsigned char),
-			 GFP_KERNEL);
+			 GFP_ATOMIC);
 	if (!packet)
 		return;
 	buffer = packet;


