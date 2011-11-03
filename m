Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631Ab1KCMe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 08:34:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933555Ab1KCMe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 08:34:29 -0400
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: avi@redhat.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, acme@ghostprotocols.net
Subject: [PATCHv2 8/9] KVM: x86 emulator: fix RDPMC privilege check
Date: Thu,  3 Nov 2011 14:33:37 +0200
Message-Id: <1320323618-10375-9-git-send-email-gleb@redhat.com>
In-Reply-To: <1320323618-10375-1-git-send-email-gleb@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@redhat.com>

RDPMC is only privileged if CR4.PCE=0.  check_rdpmc() already implements this,
so all we need to do is drop the Priv flag.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kvm/emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 8547958..c0ee85b 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3254,7 +3254,7 @@ static struct opcode twobyte_table[256] = {
 	DI(ImplicitOps | Priv, wrmsr),
 	IIP(ImplicitOps, em_rdtsc, rdtsc, check_rdtsc),
 	DI(ImplicitOps | Priv, rdmsr),
-	DIP(ImplicitOps | Priv, rdpmc, check_rdpmc),
+	DIP(ImplicitOps, rdpmc, check_rdpmc),
 	I(ImplicitOps | VendorSpecific, em_sysenter),
 	I(ImplicitOps | Priv | VendorSpecific, em_sysexit),
 	N, N,
-- 
1.7.5.3

