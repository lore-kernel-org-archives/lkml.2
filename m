Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab2CMUa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 16:30:28 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:43303 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752789Ab2CMUa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 16:30:26 -0400
Message-ID: <4F5FAE63.3090908@xenotime.net>
Date: Tue, 13 Mar 2012 13:30:27 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Michal Januszewski <spock@gentoo.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: export 'pcibios_enabled'
References: <20120313204114.e160849af7dbe5a4b4e5c0ad@canb.auug.org.au>
In-Reply-To: <20120313204114.e160849af7dbe5a4b4e5c0ad@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Export 'pcibios_enabled' so that when uvesafb is built as a
loadable module (on X86_32), the build will succeed.

ERROR: "pcibios_enabled" [drivers/video/uvesafb.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Michal Januszewski <spock@gentoo.org>
Cc:	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc:	linux-fbdev@vger.kernel.org
Cc:	x86@kernel.org
---
Applies to mainline; found in linux-next.

 arch/x86/pci/pcbios.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20120313.orig/arch/x86/pci/pcbios.c
+++ linux-next-20120313/arch/x86/pci/pcbios.c
@@ -27,6 +27,7 @@
 #define PCIBIOS_HW_TYPE2_SPEC		0x20
 
 int pcibios_enabled;
+EXPORT_SYMBOL(pcibios_enabled);
 
 /* According to the BIOS specification at:
  * http://members.datafast.net.au/dft0802/specs/bios21.pdf, we could
