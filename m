Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab1CKU7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:59:52 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:36802 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754368Ab1CKU7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:59:50 -0500
X-Sasl-enc: yxa16jm4elvpW0fSnCymgh6eIVqA68hboI537vlBuobc 1299877189
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: x86@kernel.org, Ingo Molnar <mingo@redhat.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Jan Beulich <jbeulich@novell.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: x86_64, xen: fix another wrong size directive
Date: Fri, 11 Mar 2011 21:59:38 +0100
Message-Id: <1299877178-26063-1-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest binutils (2.21.0.20110302/Ubuntu) breaks the build under
CONFIG_XEN=y due to a .size directive that refers to a non-existent
symbol.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

Hi all,

One more buglet found due to build failures with the latest binutils.

Greetings,
    Alexander

 arch/x86/kernel/entry_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index aed1ffb..bbd5c80 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1248,7 +1248,7 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 	decl PER_CPU_VAR(irq_count)
 	jmp  error_exit
 	CFI_ENDPROC
-END(do_hypervisor_callback)
+END(xen_do_hypervisor_callback)
 
 /*
  * Hypervisor uses this for application faults while it executes.
