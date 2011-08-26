Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1H0O65 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:58:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079Ab1H0O6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:58:53 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:55 2011
Message-Id: <20110826215055.794405073@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jack Steiner <steiner@sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: [28/35] x86, UV: Remove UV delay in starting slave cpus
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jack Steiner <steiner@sgi.com>

commit 05e33fc20ea5e493a2a1e7f1d04f43cdf89f83ed upstream.

Delete the 10 msec delay between the INIT and SIPI when starting
slave cpus. I can find no requirement for this delay. BIOS also
has similar code sequences without the delay.

Removing the delay reduces boot time by 40 sec. Every bit helps.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Link: http://lkml.kernel.org/r/20110805140900.GA6774@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/x2apic_uv_x.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -207,7 +207,6 @@ static int __cpuinit uv_wakeup_secondary
 	    ((start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
 	    APIC_DM_INIT;
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
-	mdelay(10);
 
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 	    (phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |


