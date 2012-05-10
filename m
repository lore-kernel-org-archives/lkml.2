Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195Ab2EJVLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:11:45 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:48482 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758093Ab2EJVJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:09:55 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-parisc@vger.kernel.org
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Subject: [PATCH 2/5] parisc: add missing forward declarations in asm/hardware.h
Date: Thu, 10 May 2012 23:01:40 +0200
Message-ID: <1970353.sFHxzMjcN0@donald.sf-tec.de>
User-Agent: KMail/4.8.3 (Linux/3.2.9-13-desktop; KDE/4.8.3; i686; ; )
In-Reply-To: <4430485.xEvkeJU8MB@donald.sf-tec.de>
References: <4430485.xEvkeJU8MB@donald.sf-tec.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
/home/buildbot/repos/linux/arch/parisc/include/asm/hardware.h:106:10: warning: ‘struct hardware_path’ declared inside parameter list [enabled by default]
/home/buildbot/repos/linux/arch/parisc/include/asm/hardware.h:106:10: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
/home/buildbot/repos/linux/arch/parisc/include/asm/hardware.h:116:59: warning: ‘struct hardware_path’ declared inside parameter list [enabled by default]
/home/buildbot/repos/linux/arch/parisc/include/asm/hardware.h:118:47: warning: ‘struct hardware_path’ declared inside parameter list [enabled by default]
/home/buildbot/repos/linux/arch/parisc/include/asm/hardware.h:119:57: warning: ‘struct hardware_path’ declared inside parameter list [enabled by default]

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
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
-- 
1.7.9.2


