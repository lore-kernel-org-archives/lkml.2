Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab0FNXW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 19:22:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44503 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab0FNXW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 19:22:56 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 15 Jun 2010 01:22:45 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <4C16AECD.50506@gmail.com>
Message-ID: <tkrat.5070b3a06affdcfa@s5r6.in-berlin.de>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
 <1276547208-26569-8-git-send-email-justinmattock@gmail.com>
 <tkrat.6f2ad8e8a9e281c2@s5r6.in-berlin.de> <4C16AECD.50506@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

which caused gcc 4.6 to warn about
    variable 'destination' set but not used.

Reported-by: Justin P. Mattock <justinmattock@gmail.com>

Since the hardware ensures that we receive only response packets with
proper destination node ID (in a given bus generation), we have no use
for destination here in the core as well as in upper layers.

(This is different with request packets.  There we pass destination node
ID to upper layers because they may for example need to check whether
this was an unicast or broadcast request.)

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-transaction.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

Index: b/drivers/firewire/core-transaction.c
===================================================================
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -881,13 +881,12 @@ void fw_core_handle_response(struct fw_c
 	unsigned long flags;
 	u32 *data;
 	size_t data_length;
-	int tcode, tlabel, destination, source, rcode;
+	int tcode, tlabel, source, rcode;
 
-	tcode       = HEADER_GET_TCODE(p->header[0]);
-	tlabel      = HEADER_GET_TLABEL(p->header[0]);
-	destination = HEADER_GET_DESTINATION(p->header[0]);
-	source      = HEADER_GET_SOURCE(p->header[1]);
-	rcode       = HEADER_GET_RCODE(p->header[1]);
+	tcode	= HEADER_GET_TCODE(p->header[0]);
+	tlabel	= HEADER_GET_TLABEL(p->header[0]);
+	source	= HEADER_GET_SOURCE(p->header[1]);
+	rcode	= HEADER_GET_RCODE(p->header[1]);
 
 	spin_lock_irqsave(&card->lock, flags);
 	list_for_each_entry(t, &card->transaction_list, link) {

-- 
Stefan Richter
-=====-==-=- -==- -====
http://arcgraph.de/sr/

