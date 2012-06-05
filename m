Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611Ab2FELFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:05:18 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:35535 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761853Ab2FELFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:05:17 -0400
Date: Tue, 5 Jun 2012 13:05:41 +0200
From: Borislav Petkov <bp@amd64.org>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: Borislav Petkov <bp@amd64.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] CMA: Do no enable it by default
Message-ID: <20120605110541.GC13495@aftab.osrc.amd.com>
References: <20120531153512.GK14515@aftab.osrc.amd.com>
 <20120531154224.GL14515@aftab.osrc.amd.com>
 <20120601110647.2c446aa7@rockpopper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120601110647.2c446aa7@rockpopper>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>
Date: Tue, 5 Jun 2012 12:52:01 +0200
Subject: [PATCH] CMA: Do no enable it by default


From: Borislav Petkov <borislav.petkov@amd.com>
Date: Tue, 5 Jun 2012 12:52:01 +0200
Subject: [PATCH] CMA: Do no enable it by default

CROSS_MEMORY_ATTACH is a MPI feature which shouldn't be enabled by
default on every linux system simply because the majority of users do
not need it.

Besides, in the config option it says "... which allow a process with
the correct privileges to directly read from or write to to another
process's address space.", which, if the reading process has somehow
gained privileges (as that never happens) is your security issue right
there.

So disable it - people who really need that normally know what they're
doing and also know how to enable it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 mm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 82fed4eb2b6f..3b6347cf4c06 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -352,7 +352,7 @@ endchoice
 config CROSS_MEMORY_ATTACH
 	bool "Cross Memory Support"
 	depends on MMU
-	default y
+	default n
 	help
 	  Enabling this option adds the system calls process_vm_readv and
 	  process_vm_writev which allow a process with the correct privileges
-- 
1.7.11.rc1


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
