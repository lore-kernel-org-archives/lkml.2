Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab1AKM2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:28:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:47428 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab1AKM2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:28:31 -0500
Date: Tue, 11 Jan 2011 12:28:13 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110110195210.GA18737@sgi.com>
References: <20110110195210.GA18737@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, UV: Fix APICID shift for Westmere processors
Message-ID: <tip-990a32d1e54b3c0f7304bec95fb883404589b3f0@git.kernel.org>
Git-Commit-ID: 990a32d1e54b3c0f7304bec95fb883404589b3f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 11 Jan 2011 12:28:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  990a32d1e54b3c0f7304bec95fb883404589b3f0
Gitweb:     http://git.kernel.org/tip/990a32d1e54b3c0f7304bec95fb883404589b3f0
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Mon, 10 Jan 2011 13:52:11 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 11 Jan 2011 12:44:45 +0100

x86, UV: Fix APICID shift for Westmere processors

Westmere processors use a different algorithm for
assigning APICIDs on SGI UV systems. The location of the
node number within the apicid is now a function of the
processor type.

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20110110195210.GA18737@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 2a3f2a7..f4f9e95 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -378,7 +378,7 @@ struct apic __refdata apic_x2apic_uv_x = {
 
 static __cpuinit void set_x2apic_extra_bits(int pnode)
 {
-	__get_cpu_var(x2apic_extra_bits) = (pnode << 6);
+	__get_cpu_var(x2apic_extra_bits) = (pnode << uvh_apicid.s.pnode_shift);
 }
 
 /*
