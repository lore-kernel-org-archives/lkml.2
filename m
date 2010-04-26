Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab0DZOGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:06:20 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:39910 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629Ab0DZOGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:06:19 -0400
Date: Mon, 26 Apr 2010 16:06:18 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       Tim Abbott <tabbott@ksplice.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH] Doublecheck for CONFIG_64
Message-ID: <20100426140618.GB2710@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

	The following patch removes a unnecessary conditional. Inside
a block making sure CONFIG_64 isn't set the option is checked again
and based on that some parts are (not) included. As the outer check
already makes sure CONFIG_64 isn't set here both checks are
unnecessary so this patch removes them.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

----
>From 32fe96794990e5e5a2cb3b2b7bcb0c49e61d4c9b Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@cs.fau.de>
Date: Mon, 26 Apr 2010 15:54:55 +0200
Subject: [PATCH] Remove redundant check for CONFIG_64

THis is a check for CONFIG_64 inside a block that is only active when
CONFIG_64 is set. So the check is actually useless and potentially
irritation.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/s390/kernel/vdso.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index 6bc9c19..6b83870 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -102,11 +102,7 @@ static void vdso_init_per_cpu_data(int cpu, struct vdso_per_cpu_data *vpcd)
 /*
  * Allocate/free per cpu vdso data.
  */
-#ifdef CONFIG_64BIT
 #define SEGMENT_ORDER	2
-#else
-#define SEGMENT_ORDER	1
-#endif
 
 int vdso_alloc_per_cpu(int cpu, struct _lowcore *lowcore)
 {
-- 
1.6.3.3









