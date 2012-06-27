Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2F0JMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:12:08 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:35963 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab2F0JME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:12:04 -0400
Date: Wed, 27 Jun 2012 12:11:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Cliff Wickman <cpw@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch -resend] [patch] tlb_uv: remove some dead code in
 parse_tunables_write()
Message-ID: <20120627091142.GY31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code isn't reachable anymore after f073cc8f39 "x86, UV: Clean up
uv_tlb.c" because we will always hit a continue statement.  This causes
a Smatch message:

arch/x86/platform/uv/tlb_uv.c:1531 parse_tunables_write()
	info: ignoring unreachable code.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I have cleaned up the commit message.  This was originally sent on
Sun, 7 Aug 2011.

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 59880af..d625792 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1528,8 +1528,6 @@ static int parse_tunables_write(struct bau_control *bcp, char *instr,
 				*tunables[cnt].tunp = val;
 			continue;
 		}
-		if (q == p)
-			break;
 	}
 	return 0;
 }
