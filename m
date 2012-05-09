Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab2EIWRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:17:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932494Ab2EIWRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:17:19 -0400
Date: Wed, 9 May 2012 18:17:13 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: torvalds@linux-foundation.org
cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 2/5] PA-RISC: fix compile errors
In-Reply-To: <Pine.LNX.4.64.1205091758310.1272@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1205091816470.1272@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1205091758310.1272@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rolf Eike Beer <eike-kernel@sf-tec.de>

Fixes this warnings:

In file included from /home/buildbot/repos/linux/arch/parisc/include/asm/processor.h:15:0,
                 from /home/buildbot/repos/linux/arch/parisc/include/asm/spinlock.h:4,
                 from /home/buildbot/repos/linux/arch/parisc/include/asm/atomic.h:20,
                 from /home/buildbot/repos/linux/include/linux/atomic.h:4,
                 from /home/buildbot/repos/linux/arch/parisc/include/asm/bitops.h:11,
                 from /home/buildbot/repos/linux/include/linux/bitops.h:22,
                 from /home/buildbot/repos/linux/include/linux/kernel.h:19,
                 from /home/buildbot/repos/linux/include/linux/sched.h:55,
                 from /home/buildbot/repos/linux/arch/parisc/kernel/asm-offsets.c:31:
/home/buildbot/repos/linux/arch/parisc/include/asm/hardware.h:106:10: warning: "struct hardware_path" declared inside parameter list [enabled by default]
/home/buildbot/repos/linux/arch/parisc/include/asm/hardware.h:106:10: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
/home/buildbot/repos/linux/arch/parisc/include/asm/hardware.h:116:59: warning: "struct hardware_path" declared inside parameter list [enabled by default]
/home/buildbot/repos/linux/arch/parisc/include/asm/hardware.h:118:47: warning: "struct hardware_path" declared inside parameter list [enabled by default]
/home/buildbot/repos/linux/arch/parisc/include/asm/hardware.h:119:57: warning: "struct hardware_path" declared inside parameter list [enabled by default]

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 arch/parisc/include/asm/hardware.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/parisc/include/asm/hardware.h b/arch/parisc/include/asm/hardware.h
index 4e96268..036e703 100644
--- a/arch/parisc/include/asm/hardware.h
+++ b/arch/parisc/include/asm/hardware.h
@@ -95,12 +95,14 @@ struct bc_module {
 #define HPHW_MC	       15
 #define HPHW_FAULTY    31
 
+struct parisc_device_id;
 
 /* hardware.c: */
 extern const char *parisc_hardware_description(struct parisc_device_id *id);
 extern enum cpu_type parisc_get_cpu_type(unsigned long hversion);
 
 struct pci_dev;
+struct hardware_path;
 
 /* drivers.c: */
 extern struct parisc_device *alloc_pa_dev(unsigned long hpa,

