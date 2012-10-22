Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2JVNRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:17:37 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35487 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab2JVNRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:17:36 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 22 Oct 2012 15:17:17 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: <linux1394-devel@lists.sourceforge.net>
Cc: yang yeping <yangyeping_666@hotmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] tools/firewire: nosy-dump: check for allocation failure
Message-ID: <20121022151717.35f585a7@stein>
In-Reply-To: <BAY167-W2929963ACD86D27998ACE8BB7A0@phx.gbl>
References: <BAY167-W2929963ACD86D27998ACE8BB7A0@phx.gbl>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Behavior of null pointer dereference is undefined in the C language.
Portably implement the desired behavior.

Reported-by: Yang Yeping <yangyeping_666@hotmail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 tools/firewire/nosy-dump.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/firewire/nosy-dump.c
+++ b/tools/firewire/nosy-dump.c
@@ -150,6 +150,8 @@ subaction_create(uint32_t *data, size_t
 
 	/* we put the ack in the subaction struct for easy access. */
 	sa = malloc(sizeof *sa - sizeof sa->packet + length);
+	if (!sa)
+		exit(EXIT_FAILURE);
 	sa->ack = data[length / 4 - 1];
 	sa->length = length;
 	memcpy(&sa->packet, data, length);
@@ -180,6 +182,8 @@ link_transaction_lookup(int request_node
 	}
 
 	t = malloc(sizeof *t);
+	if (!t)
+		exit(EXIT_FAILURE);
 	t->request_node = request_node;
 	t->response_node = response_node;
 	t->tlabel = tlabel;

-- 
Stefan Richter
-=====-===-- =-=- =-==-
http://arcgraph.de/sr/
