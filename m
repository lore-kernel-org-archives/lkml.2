Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab1FPMPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:15:04 -0400
Received: from relay2.sgi.com ([192.48.179.30]:47382 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757219Ab1FPMO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:14:59 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/8 v3] x86, UV: allow for non-consecutive sockets
Cc: mingo@elte.hu
Message-Id: <E1QXBUZ-0004gE-UY@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 16 Jun 2011 07:16:11 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Fix for the theoretical case in which there is a socket 1 on a blade
with no socket 0.
Only call make_per_cpu_thp() for present sockets.

We have only seen this fail for internal configurations.

Diffed against 3.0.0-rc3

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/platform/uv/tlb_uv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
@@ -1752,10 +1752,10 @@ static int __init summarize_uvhub_socket
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
