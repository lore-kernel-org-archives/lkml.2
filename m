Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab2HOTth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:49:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:36482 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab2HOTt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:27 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 026/165] sparc: fix array bounds error setting up PCIC NMI trap
Date: Wed, 15 Aug 2012 15:46:10 -0400
Message-ID: <1345060109-9187-27-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <Ian.Campbell@citrix.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4a0342ca8e8150bd47e7118a76e300692a1b6b7b upstream.

  CC      arch/sparc/kernel/pcic.o
arch/sparc/kernel/pcic.c: In function 'pcic_probe':
arch/sparc/kernel/pcic.c:359:33: error: array subscript is above array bounds [-Werror=array-bounds]
arch/sparc/kernel/pcic.c:359:8: error: array subscript is above array bounds [-Werror=array-bounds]
arch/sparc/kernel/pcic.c:360:33: error: array subscript is above array bounds [-Werror=array-bounds]
arch/sparc/kernel/pcic.c:360:8: error: array subscript is above array bounds [-Werror=array-bounds]
arch/sparc/kernel/pcic.c:361:33: error: array subscript is above array bounds [-Werror=array-bounds]
arch/sparc/kernel/pcic.c:361:8: error: array subscript is above array bounds [-Werror=array-bounds]
cc1: all warnings being treated as errors

I'm not particularly familiar with sparc but t_nmi (defined in head_32.S via
the TRAP_ENTRY macro) and pcic_nmi_trap_patch (defined in entry.S) both appear
to be 4 instructions long and I presume from the usage that instructions are
int sized.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/sparc/kernel/pcic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index d36a8d3..2479ecd 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -349,8 +349,8 @@ int __init pcic_probe(void)
 	strcpy(pbm->prom_name, namebuf);
 
 	{
-		extern volatile int t_nmi[1];
-		extern int pcic_nmi_trap_patch[1];
+		extern volatile int t_nmi[4];
+		extern int pcic_nmi_trap_patch[4];
 
 		t_nmi[0] = pcic_nmi_trap_patch[0];
 		t_nmi[1] = pcic_nmi_trap_patch[1];
-- 
1.7.12.rc2

