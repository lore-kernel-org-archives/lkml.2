Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1GLUA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:00:28 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:49172 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab1GLUAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:00:24 -0400
Message-ID: <4E1CA7D6.4090203@web.de>
Date: Tue, 12 Jul 2011 22:00:22 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH] KVM: x86: Apply required parentheses in __check_direct_spte_mmio_pf
References: <4E1B4CF8.605@cn.fujitsu.com> <4E1B5018.7070008@cn.fujitsu.com>
In-Reply-To: <4E1B5018.7070008@cn.fujitsu.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+yPl2321ftemIvhSIuCxryc5Vr901BVbbNWCvf
	XIpMWuto3SlKURXfs7Zjld23TQFg8FFSpld9rJ/Frt5+VCtpBn
	QjbTPAYRg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Comparison takes precedence over bitwise &, but the latter needs to be
evaluated first here.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---

Avi, how's your 32-bit buildbot?

 arch/x86/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d3d188e..9335e1b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -448,7 +448,7 @@ static bool __check_direct_spte_mmio_pf(u64 spte)
 
 	/* It is valid if the spte is being zapped. */
 	if (sspte.spte_low == 0ull &&
-	      sspte.spte_high & high_mmio_mask == high_mmio_mask)
+	    (sspte.spte_high & high_mmio_mask) == high_mmio_mask)
 		return true;
 
 	return false;
