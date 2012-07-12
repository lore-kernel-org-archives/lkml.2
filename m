Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471Ab2GLXt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:49:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759430Ab2GLWgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:36:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 013/187] powerpc/kvm: sldi should be sld
Date: Thu, 12 Jul 2012 15:32:49 -0700
Message-Id: <20120712191523.487081939@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 2f584a146a2965b82fce89b8d2f95dc5cfe468d0 upstream.

Since we are taking a registers, this should never have been an sldi.
Talking to paulus offline, this is the correct fix.

Was introduced by:
 commit 19ccb76a1938ab364a412253daec64613acbf3df
 Author: Paul Mackerras <paulus@samba.org>
 Date:   Sat Jul 23 17:42:46 2011 +1000

Talking to paulus, this shouldn't be a literal.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -776,7 +776,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_201)
 	lwz	r3,VCORE_NAPPING_THREADS(r5)
 	lwz	r4,VCPU_PTID(r9)
 	li	r0,1
-	sldi	r0,r0,r4
+	sld	r0,r0,r4
 	andc.	r3,r3,r0		/* no sense IPI'ing ourselves */
 	beq	43f
 	mulli	r4,r4,PACA_SIZE		/* get paca for thread 0 */


