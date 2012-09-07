Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab2IGGx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:53:59 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38067 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab2IGGx6 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 7 Sep 2012 02:53:58 -0400
Message-Id: <5049B65C020000780009990C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 07 Sep 2012 07:54:52 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Alex Shi" <alex.shi@intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix range check in tlbflush debugfs interface
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the shift count settable there is used for shifting values of
type "unsigned long", its value must not match or exceed BITS_PER_LONG
(otherwise the shift operations are undefined). Similarly, the value
must not be negative (but -1 must be permitted, as that's the value
used to distinguish the case of the fine grained flushing being
disabled).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Alex Shi <alex.shi@intel.com>

---
 arch/x86/mm/tlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.6-rc4/arch/x86/mm/tlb.c
+++ 3.6-rc4-x86-tlb_flushall_shift-limits/arch/x86/mm/tlb.c
@@ -320,7 +320,7 @@ static ssize_t tlbflush_write_file(struc
 	if (kstrtos8(buf, 0, &shift))
 		return -EINVAL;
 
-	if (shift > 64)
+	if (shift < -1 || shift >= BITS_PER_LONG)
 		return -EINVAL;
 
 	tlb_flushall_shift = shift;



