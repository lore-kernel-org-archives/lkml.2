Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0IXQzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:55:03 -0400
Received: from kroah.org ([198.145.64.141]:38329 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932651Ab0IXQ2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:22 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:17 2010
Message-Id: <20100924162617.854085624@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Patrick Simmons <linuxrocks123@netscape.net>,
        Andi Kleen <ak@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Robert Richter <robert.richter@amd.com>
Subject: [34/80] oprofile: Add Support for Intel CPU Family 6 / Model 22 (Intel Celeron 540)
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick Simmons <linuxrocks123@netscape.net>

commit c33f543d320843e1732534c3931da4bbd18e6c14 upstream.

This patch adds CPU type detection for the Intel Celeron 540, which is
part of the Core 2 family according to Wikipedia; the family and ID pair
is absent from the Volume 3B table referenced in the source code
comments.  I have tested this patch on an Intel Celeron 540 machine
reporting itself as Family 6 Model 22, and OProfile runs on the machine
without issue.

Spec:

 http://download.intel.com/design/mobile/SPECUPDT/317667.pdf

Signed-off-by: Patrick Simmons <linuxrocks123@netscape.net>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/oprofile/nmi_int.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -671,7 +671,9 @@ static int __init ppro_init(char **cpu_t
 	case 14:
 		*cpu_type = "i386/core";
 		break;
-	case 15: case 23:
+	case 0x0f:
+	case 0x16:
+	case 0x17:
 		*cpu_type = "i386/core_2";
 		break;
 	case 0x1a:


