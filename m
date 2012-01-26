Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab2AZNhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:37:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36048 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2AZNhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:37:33 -0500
Date: Thu, 26 Jan 2012 05:37:10 -0800
From: tip-bot for Russ Anderson <rja@sgi.com>
Message-ID: <tip-5a51467b146ab7948d2f6812892eac120a30529c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, rja@sgi.com, hpa@zytor.com, mingo@redhat.com,
        stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, rja@sgi.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20120119020753.GA7228@sgi.com>
References: <20120119020753.GA7228@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/uv: Fix uv_gpa_to_soc_phys_ram() shift
Git-Commit-ID: 5a51467b146ab7948d2f6812892eac120a30529c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 05:37:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a51467b146ab7948d2f6812892eac120a30529c
Gitweb:     http://git.kernel.org/tip/5a51467b146ab7948d2f6812892eac120a30529c
Author:     Russ Anderson <rja@sgi.com>
AuthorDate: Wed, 18 Jan 2012 20:07:54 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Jan 2012 10:58:27 +0100

x86/uv: Fix uv_gpa_to_soc_phys_ram() shift

uv_gpa_to_soc_phys_ram() was inadvertently ignoring the
shift values.  This fix takes the shift into account.

Signed-off-by: Russ Anderson <rja@sgi.com>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/20120119020753.GA7228@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_hub.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 54a13aa..21f7385 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -318,13 +318,13 @@ uv_gpa_in_mmr_space(unsigned long gpa)
 /* UV global physical address --> socket phys RAM */
 static inline unsigned long uv_gpa_to_soc_phys_ram(unsigned long gpa)
 {
-	unsigned long paddr = gpa & uv_hub_info->gpa_mask;
+	unsigned long paddr;
 	unsigned long remap_base = uv_hub_info->lowmem_remap_base;
 	unsigned long remap_top =  uv_hub_info->lowmem_remap_top;
 
 	gpa = ((gpa << uv_hub_info->m_shift) >> uv_hub_info->m_shift) |
 		((gpa >> uv_hub_info->n_lshift) << uv_hub_info->m_val);
-	gpa = gpa & uv_hub_info->gpa_mask;
+	paddr = gpa & uv_hub_info->gpa_mask;
 	if (paddr >= remap_base && paddr < remap_base + remap_top)
 		paddr -= remap_base;
 	return paddr;
