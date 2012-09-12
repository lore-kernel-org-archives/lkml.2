Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2IMAoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:44:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab2ILXaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:30:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 004/108] ARM: 7483/1: vfp: only advertise VFPv4 in hwcaps if CONFIG_VFPv3 is enabled
Date: Wed, 12 Sep 2012 16:28:02 -0700
Message-Id: <20120912232450.831959201@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 3d9fb0038a9b02febb01efc79a4a5d97f1822a90 upstream.

VFPv4 support depends on the VFPv3 context save/restore code, so only
advertise support in the hwcaps if the kernel can actually handle it.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/vfp/vfpmodule.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -719,8 +719,10 @@ static int __init vfp_init(void)
 			if ((fmrx(MVFR1) & 0x000fff00) == 0x00011100)
 				elf_hwcap |= HWCAP_NEON;
 #endif
+#ifdef CONFIG_VFPv3
 			if ((fmrx(MVFR1) & 0xf0000000) == 0x10000000)
 				elf_hwcap |= HWCAP_VFPv4;
+#endif
 		}
 	}
 	return 0;


