Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab1FUPRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:17:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:59965 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab1FUPRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:17:17 -0400
Date: Tue, 21 Jun 2011 15:17:10 GMT
From: "tip-bot for cpw@sgi.com" <cpw@sgi.com>
Message-ID: <tip-9c9153db22870c3f37add83bea30500fcc268a73@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110621122242.363757364@sgi.com>
References: <20110621122242.363757364@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Allow for non-consecutive sockets
Git-Commit-ID: 9c9153db22870c3f37add83bea30500fcc268a73
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Jun 2011 15:17:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c9153db22870c3f37add83bea30500fcc268a73
Gitweb:     http://git.kernel.org/tip/9c9153db22870c3f37add83bea30500fcc268a73
Author:     cpw@sgi.com <cpw@sgi.com>
AuthorDate: Tue, 21 Jun 2011 07:21:28 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Jun 2011 14:50:32 +0200

x86, UV: Allow for non-consecutive sockets

Fix for the topology in which there is a socket 1 on a blade
with no socket 0.

Only call make_per_cpu_thp() for present sockets.
We have only seen this fail for internal configurations.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Link: http://lkml.kernel.org/r/20110621122242.363757364@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/uv/tlb_uv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 34be650..7623b08 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1752,10 +1752,10 @@ static int __init summarize_uvhub_sockets(int nuvhubs,
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
