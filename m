Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab2AXC43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:56:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694Ab2AXCrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:47:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:30 2012
Message-Id: <20120124023930.283915800@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jack Steiner <steiner@sgi.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [072/129] x86, UV: Update Boot messages for SGI UV2 platform
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1306
Lines: 38

From: Jack Steiner <steiner@sgi.com>

commit da517a08ac5913cd80ce3507cddd00f2a091b13c upstream.

SGI UV systems print a message during boot:

	UV: Found <num> blades

Due to packaging changes, the blade count is not accurate for
on the next generation of the platform. This patch corrects the
count.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Link: http://lkml.kernel.org/r/20120106191900.GA19772@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/x2apic_uv_x.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -769,7 +769,12 @@ void __init uv_system_init(void)
 	for(i = 0; i < UVH_NODE_PRESENT_TABLE_DEPTH; i++)
 		uv_possible_blades +=
 		  hweight64(uv_read_local_mmr( UVH_NODE_PRESENT_TABLE + i * 8));
-	printk(KERN_DEBUG "UV: Found %d blades\n", uv_num_possible_blades());
+
+	/* uv_num_possible_blades() is really the hub count */
+	printk(KERN_INFO "UV: Found %d blades, %d hubs\n",
+			is_uv1_hub() ? uv_num_possible_blades() :
+			(uv_num_possible_blades() + 1) / 2,
+			uv_num_possible_blades());
 
 	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
 	uv_blade_info = kzalloc(bytes, GFP_KERNEL);


