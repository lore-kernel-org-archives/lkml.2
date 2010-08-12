Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418Ab0HLAVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:21:01 -0400
Received: from kroah.org ([198.145.64.141]:60432 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932890Ab0HLAHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:07:43 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:13 2010
Message-Id: <20100812000612.971650948@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Scott Wood <scottwood@freescale.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [03/67] perf, powerpc: fsl_emb: Restore setting perf_sample_data.period
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Scott Wood <scottwood@freescale.com>

commit 69e77a8b0426ded5d924eea7dbe4eca51e09f530 upstream.

Commit 6b95ed345b9faa4ab3598a82991968f2e9f851bb changed from
a struct initializer to perf_sample_data_init(), but the setting
of the .period member was left out.

Signed-off-by: Scott Wood <scottwood@freescale.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/perf_event_fsl_emb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ b/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -569,6 +569,7 @@ static void record_and_restart(struct pe
 		struct perf_sample_data data;
 
 		perf_sample_data_init(&data, 0);
+		data.period = event->hw.last_period;
 
 		if (perf_event_overflow(event, nmi, &data, regs)) {
 			/*


