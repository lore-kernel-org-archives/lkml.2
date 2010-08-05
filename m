Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934053Ab0HEUR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:17:28 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55293 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932963Ab0HEURY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:17:24 -0400
Date: Thu, 5 Aug 2010 22:17:22 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/42] arch/mips/kernel: Adjust confusing if indentation
Message-ID: <Pine.LNX.4.64.1008052217010.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Indent the branch of an if.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/mips/kernel/kspd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/kspd.c b/arch/mips/kernel/kspd.c
index 80e2ba6..29811f0 100644
--- a/arch/mips/kernel/kspd.c
+++ b/arch/mips/kernel/kspd.c
@@ -251,7 +251,7 @@ void sp_work_handle_request(void)
  		memset(&tz, 0, sizeof(tz));
  		if ((ret.retval = sp_syscall(__NR_gettimeofday, (int)&tv,
 					     (int)&tz, 0, 0)) == 0)
-		ret.retval = tv.tv_sec;
+			ret.retval = tv.tv_sec;
 		break;
 
  	case MTSP_SYSCALL_EXIT:
