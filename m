Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab2FESDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 14:03:32 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:37937 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab2FESDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 14:03:31 -0400
Date: Tue, 5 Jun 2012 20:03:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christopher Yeoh <cyeoh@au1.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH -v2] CMA: Do no enable it by default
Message-ID: <20120605180355.GR13495@aftab.osrc.amd.com>
References: <20120531153512.GK14515@aftab.osrc.amd.com>
 <20120531154224.GL14515@aftab.osrc.amd.com>
 <20120601110647.2c446aa7@rockpopper>
 <20120605110541.GC13495@aftab.osrc.amd.com>
 <CA+55aFxu9ZfbKuWdhmADreRS9wxzMyW9buoVkd=B4Yqi=bxbiw@mail.gmail.com>
 <20120605170921.GO13495@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120605170921.GO13495@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

CROSS_MEMORY_ATTACH is a MPI feature which shouldn't be enabled by
default on every linux system simply because the majority of users do
not need it.

In the config option it says "... which allow a process with the correct
privileges to directly read from or write to to another process's
address space." but this is the normal ptrace case where if one process
has the required privileges, it can access another process' address
space.

So disable it - people who really need that normally know what they're
doing and also know how to enable it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---

-v2: Correct commit message.

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
