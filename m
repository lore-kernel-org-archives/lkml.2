Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab1FPPxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:53:55 -0400
Received: from relay1.sgi.com ([192.48.179.29]:40530 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab1FPPxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:53:53 -0400
Message-Id: <20110616155352.879591728@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 16 Jun 2011 10:10:35 -0500
From: cpw@sgi.com
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, x86@kernel.org
Subject: [patch 3/8 v4] x86, UV: allow for non-consecutive sockets
References: <20110616151032.729980001@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=tlb_uv_nonconsecsockets
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for the topology in which there is a socket 1 on a blade with no socket 0.

Diffed against 3.0.0-rc3

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---

Only call make_per_cpu_thp() for present sockets.
We have only seen this fail for internal configurations.

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

