Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab0KSWdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:33:47 -0500
Received: from kroah.org ([198.145.64.141]:44981 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932554Ab0KSV62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:28 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:39 2010
Message-Id: <20101119215639.901029025@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:55:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Len Brown <len.brown@intel.com>, Tom Gundersen <teg@jklm.no>
Subject: [14/82] intel_idle: do not use the LAPIC timer for ATOM C2
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Len Brown <len.brown@intel.com>

commit c25d29952b2a8c9aaf00e081c9162a0e383030cd upstream.

If we use the LAPIC timer during ATOM C2 on
some nvidia chisets, the system stalls.

https://bugzilla.kernel.org/show_bug.cgi?id=21032

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Tom Gundersen <teg@jklm.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/idle/intel_idle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -308,7 +308,7 @@ static int intel_idle_probe(void)
 		break;
 
 	case 0x1C:	/* 28 - Atom Processor */
-		lapic_timer_reliable_states = (1 << 2) | (1 << 1); /* C2, C1 */
+		lapic_timer_reliable_states = (1 << 1); /* C1 */
 		cpuidle_state_table = atom_cstates;
 		choose_substate = choose_zero_substate;
 		break;


