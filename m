Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081Ab2BIQIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 11:08:06 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:31086 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753776Ab2BIQIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 11:08:01 -0500
X-Greylist: delayed 5698 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Feb 2012 11:08:01 EST
X-SpamScore: 3
X-BigFish: VPS3(zz853kzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ4VH2-02-AAR-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] perf-tool: Change perf_guest default back to false
Date: Thu, 9 Feb 2012 17:07:39 +0100
Message-ID: <1328803659-30449-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1328803659-30449-1-git-send-email-joerg.roedel@amd.com>
References: <1328803659-30449-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting perf_guest to true by default makes no sense because
the perf subcommands can not setup guest symbol information
and thus not process and guest samples. The only exception
is perf-kvm which changes the perf_guest value on its own.
So change the default for perf_guest back to false.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 tools/perf/util/util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 8131410..fb25d13 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -6,7 +6,7 @@
  * XXX We need to find a better place for these things...
  */
 bool perf_host  = true;
-bool perf_guest = true;
+bool perf_guest = false;
 
 void event_attr_init(struct perf_event_attr *attr)
 {
-- 
1.7.5.4


