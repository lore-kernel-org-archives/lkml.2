Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab1LENVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:21:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57416 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab1LENVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:21:02 -0500
Date: Mon, 5 Dec 2011 05:20:38 -0800
From: tip-bot for Jack Steiner <steiner@sgi.com>
Message-ID: <tip-b495e039b4ce2ce4a96b3006004faf082f4d50e2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111129210058.GA20452@sgi.com>
References: <20111129210058.GA20452@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, UV: Fix UV2 hub part number
Git-Commit-ID: b495e039b4ce2ce4a96b3006004faf082f4d50e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:20:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b495e039b4ce2ce4a96b3006004faf082f4d50e2
Gitweb:     http://git.kernel.org/tip/b495e039b4ce2ce4a96b3006004faf082f4d50e2
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Tue, 29 Nov 2011 15:00:58 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 11:49:52 +0100

x86, UV: Fix UV2 hub part number

There was a mixup when the SGI UV2 hub chip was sent to be
fabricated, and it ended up with the wrong part number in the
HRP_NODE_ID mmr. Future versions of the chip will (may) have the
correct part number. Change the UV infrastructure to recognize
both part numbers as valid IDs of a UV2 hub chip.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Link: http://lkml.kernel.org/r/20111129210058.GA20452@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_mmrs.h  |    1 +
 arch/x86/kernel/apic/x2apic_uv_x.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_mmrs.h b/arch/x86/include/asm/uv/uv_mmrs.h
index 10474fb..cf1d736 100644
--- a/arch/x86/include/asm/uv/uv_mmrs.h
+++ b/arch/x86/include/asm/uv/uv_mmrs.h
@@ -57,6 +57,7 @@
 
 #define UV1_HUB_PART_NUMBER	0x88a5
 #define UV2_HUB_PART_NUMBER	0x8eb8
+#define UV2_HUB_PART_NUMBER_X	0x1111
 
 /* Compat: if this #define is present, UV headers support UV2 */
 #define UV2_HUB_IS_SUPPORTED	1
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 62ae300..9d59bba 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -93,6 +93,8 @@ static int __init early_get_pnodeid(void)
 
 	if (node_id.s.part_number == UV2_HUB_PART_NUMBER)
 		uv_min_hub_revision_id += UV2_HUB_REVISION_BASE - 1;
+	if (node_id.s.part_number == UV2_HUB_PART_NUMBER_X)
+		uv_min_hub_revision_id += UV2_HUB_REVISION_BASE - 1;
 
 	uv_hub_info->hub_revision = uv_min_hub_revision_id;
 	pnode = (node_id.s.node_id >> 1) & ((1 << m_n_config.s.n_skt) - 1);
