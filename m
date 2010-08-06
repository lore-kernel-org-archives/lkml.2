Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965076Ab0HFSm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:42:27 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35723 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965069Ab0HFSmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:42:15 -0400
Subject: [PATCH] powerpc: fix i8042 module build error
To: martyn.welch@ge.com, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 06 Aug 2010 12:42:12 -0600
Message-ID: <20100806183839.32149.6238.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_i8042_{kbd,aux}_irq needs to be exported

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Stephen and Ben, this fixes up the build error in linux-next.  If you prefer,
I can stuff this patch into my next-powerpc branch.  Ben, I've got other
commits in that branch that I'll be sending to you early next week anyway.

 arch/powerpc/kernel/setup-common.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 15ade0d..9d4882a 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -96,7 +96,9 @@ struct screen_info screen_info = {
 
 /* Variables required to store legacy IO irq routing */
 int of_i8042_kbd_irq;
+EXPORT_SYMBOL_GPL(of_i8042_kbd_irq);
 int of_i8042_aux_irq;
+EXPORT_SYMBOL_GPL(of_i8042_aux_irq);
 
 #ifdef __DO_IRQ_CANON
 /* XXX should go elsewhere eventually */

