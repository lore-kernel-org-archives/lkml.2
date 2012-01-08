Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2AHLwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 06:52:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39248 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2AHLwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 06:52:18 -0500
Date: Sun, 8 Jan 2012 03:51:56 -0800
From: tip-bot for Jack Steiner <steiner@sgi.com>
Message-ID: <tip-da517a08ac5913cd80ce3507cddd00f2a091b13c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        steiner@sgi.com, stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        steiner@sgi.com, stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120106191900.GA19772@sgi.com>
References: <20120106191900.GA19772@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, UV:
  Update Boot messages for SGI UV2 platform
Git-Commit-ID: da517a08ac5913cd80ce3507cddd00f2a091b13c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 08 Jan 2012 03:52:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da517a08ac5913cd80ce3507cddd00f2a091b13c
Gitweb:     http://git.kernel.org/tip/da517a08ac5913cd80ce3507cddd00f2a091b13c
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Fri, 6 Jan 2012 13:19:00 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Jan 2012 12:35:44 +0100

x86, UV: Update Boot messages for SGI UV2 platform

SGI UV systems print a message during boot:

	UV: Found <num> blades

Due to packaging changes, the blade count is not accurate for
on the next generation of the platform. This patch corrects the
count.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/20120106191900.GA19772@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 9d59bba..79b05b8 100644
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
