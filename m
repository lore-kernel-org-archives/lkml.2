Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab0LLXvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:51:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36890 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab0LLXsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:39 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: philb@gnu.org, davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [211/223] econet: fix CVE-2010-3850
Message-Id: <20101212234838.8A2EBB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Phil Blundell <philb@gnu.org>

commit 16c41745c7b92a243d0874f534c1655196c64b74 upstream.

Add missing check for capable(CAP_NET_ADMIN) in SIOCSIFADDR operation.

Signed-off-by: Phil Blundell <philb@gnu.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/econet/af_econet.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/net/econet/af_econet.c
===================================================================
--- linux.orig/net/econet/af_econet.c
+++ linux/net/econet/af_econet.c
@@ -661,6 +661,9 @@ static int ec_dev_ioctl(struct socket *s
 	err = 0;
 	switch (cmd) {
 	case SIOCSIFADDR:
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
+
 		edev = dev->ec_ptr;
 		if (edev == NULL) {
 			/* Magic up a new one. */
