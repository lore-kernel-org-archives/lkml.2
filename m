Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab0KSWRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:17:41 -0500
Received: from kroah.org ([198.145.64.141]:52869 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001Ab0KSWEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:09 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:23 2010
Message-Id: <20101119220123.408063364@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:00:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Len Brown <len.brown@intel.com>, Tom Gundersen <teg@jklm.no>
Subject: [15/66] intel_idle: do not use the LAPIC timer for ATOM C2
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
@@ -276,7 +276,7 @@ static int intel_idle_probe(void)
 
 	case 0x1C:	/* 28 - Atom Processor */
 	case 0x26:	/* 38 - Lincroft Atom Processor */
-		lapic_timer_reliable_states = (1 << 2) | (1 << 1); /* C2, C1 */
+		lapic_timer_reliable_states = (1 << 1); /* C1 */
 		cpuidle_state_table = atom_cstates;
 		break;
 #ifdef FUTURE_USE


