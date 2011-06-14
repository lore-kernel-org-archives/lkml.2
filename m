Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1FNXFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 19:05:46 -0400
Received: from relay2.sgi.com ([192.48.179.30]:60820 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751624Ab1FNXFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 19:05:44 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3 of 6] x86, UV: allow for non-consecutive sockets
Cc: mingo@elte.hu
Message-Id: <E1QWchA-0004NC-P7@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Tue, 14 Jun 2011 18:06:52 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Fix for the theoretical case in which there is a socket 1 on a blade
but no socket 0.
Only call make_per_cpu_thp() for present sockets.

(applies with fuzz if not after earlier patches)

Diffed against 3.0.0-rc3

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/platform/uv/tlb_uv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
@@ -1753,10 +1753,10 @@ static int __init summarize_uvhub_socket
 				sdp = &bdp->socket[socket];
 				if (scan_sock(sdp, bdp, &smaster, &hmaster))
 					return 1;
+				make_per_cpu_thp(smaster);
 			}
 			socket++;
 			socket_mask = (socket_mask >> 1);
-			make_per_cpu_thp(smaster);
 		}
 	}
 	return 0;
