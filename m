Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab1KCB6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:58:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440Ab1KCBjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:39:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:40 2011
Message-Id: <20111102222740.333750492@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:25:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [007/101] sparc: fix array bounds error setting up PCIC NMI trap
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <Ian.Campbell@citrix.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/kernel/pcic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


