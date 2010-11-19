Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab0KSWfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:35:23 -0500
Received: from kroah.org ([198.145.64.141]:44928 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276Ab0KSV6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:23 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:39 2010
Message-Id: <20101119215639.237258651@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:55:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [06/82] powerpc/perf: Fix sampling enable for PPC970
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Mackerras <paulus@samba.org>

commit 9f5f9ffe50e90ed73040d2100db8bfc341cee352 upstream.

The logic to distinguish marked instruction events from ordinary events
on PPC970 and derivatives was flawed.  The result is that instruction
sampling didn't get enabled in the PMU for some marked instruction
events, so they would never trigger.  This fixes it by adding the
appropriate break statements in the switch statement.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/ppc970-pmu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/kernel/ppc970-pmu.c
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -169,9 +169,11 @@ static int p970_marked_instr_event(u64 e
 	switch (unit) {
 	case PM_VPU:
 		mask = 0x4c;		/* byte 0 bits 2,3,6 */
+		break;
 	case PM_LSU0:
 		/* byte 2 bits 0,2,3,4,6; all of byte 1 */
 		mask = 0x085dff00;
+		break;
 	case PM_LSU1L:
 		mask = 0x50 << 24;	/* byte 3 bits 4,6 */
 		break;


