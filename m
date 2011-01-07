Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab1AGGvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 01:51:11 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:38982 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab1AGGvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 01:51:09 -0500
Message-ID: <4D26B7A4.9000209@oracle.com>
Date: Fri, 07 Jan 2011 14:50:12 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/CATLAF_1292475699435-498544290 Thunderbird/3.1.7
MIME-Version: 1.0
To: jeremy@goop.org, ian.campbell@citrix.com,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-fbdev@vger.kernel.org, xen-devel@lists.xensource.com,
        gurudas.pai@oracle.com, guru.anbalagane@oracle.com,
        greg.marsden@oracle.com, joe.jin@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [patch] xen-event: validate irq before get evtchn by irq
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When get event channel by irq by irq, may irq is not a valid one under
some condition -- so far we found irq is -1 during suspend/resume, so
worth to validate it rather than return incorrect data.

Please review and comment.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Tested-by: Gurudas Pai <gurudas.pai@oracle.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

---
 events.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index ac7b42f..006dd7b 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -175,6 +175,9 @@ static struct irq_info *info_for_irq(unsigned irq)
 
 static unsigned int evtchn_from_irq(unsigned irq)
 {
+	if (WARN(irq < 0 || irq >= nr_irqs, "Invalid irq %d!\n", irq))
+		return 0;
+
 	return info_for_irq(irq)->evtchn;
 }
 

