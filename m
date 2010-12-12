Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab0LLXsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36657 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab0LLXsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:05 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: drosenberg@vsecurity.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [179/223] DECnet: don't leak uninitialized stack byte
Message-Id: <20101212234804.4F899B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 3c6f27bf33052ea6ba9d82369fb460726fb779c0 upstream.

A single uninitialized padding byte is leaked to userspace.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/decnet/af_decnet.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/net/decnet/af_decnet.c
===================================================================
--- linux.orig/net/decnet/af_decnet.c
+++ linux/net/decnet/af_decnet.c
@@ -1556,6 +1556,8 @@ static int __dn_getsockopt(struct socket
 			if (r_len > sizeof(struct linkinfo_dn))
 				r_len = sizeof(struct linkinfo_dn);
 
+			memset(&link, 0, sizeof(link));
+
 			switch(sock->state) {
 				case SS_CONNECTING:
 					link.idn_linkstate = LL_CONNECTING;
