Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab0KMQpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 11:45:36 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33183 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab0KMQpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 11:45:17 -0500
Date: Sat, 13 Nov 2010 08:44:37 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: [PATCH -next] x86/mrst: force support code to be built
Message-Id: <20101113084437.a9707260.randy.dunlap@oracle.com>
In-Reply-To: <20101112130547.c2a3c2c1.sfr@canb.auug.org.au>
References: <20101112130547.c2a3c2c1.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix mrst.c build: make sure that its called functions are built.

arch/x86/built-in.o: In function `mrst_reboot':
mrst.c:(.text+0x2250b): undefined reference to `intel_scu_ipc_simple_command'
arch/x86/built-in.o: In function `mrst_power_off':
mrst.c:(.text+0x2252e): undefined reference to `intel_scu_ipc_simple_command'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20101112.orig/arch/x86/Kconfig
+++ linux-next-20101112/arch/x86/Kconfig
@@ -387,6 +387,7 @@ config X86_MRST
 	select APB_TIMER
 	select I2C
 	select SPI
+	select X86_PLATFORM_DEVICES
 	---help---
 	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
 	  Internet Device(MID) platform. Moorestown consists of two chips:
