Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab0EEABI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:01:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10577 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab0EEABG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:01:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=l/Vm1eyJ1mwNzoDHVLXx/dL+uYquOKNh7gcverTMmz94scynuYypehWlZCPw+WMX6
	O2QBRNEi+gdBS+KG6+WvQ==
Date: Tue, 4 May 2010 17:00:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] x86: fix fake apicid to node mapping for numa emulation
Message-ID: <alpine.DEB.2.00.1005041659400.13683@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apicids must be mapped to the lowest node ids to maintain generic kernel
use of functions such as cpu_to_node() that determine device affinity.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Third resend of the same patch.

 arch/x86/mm/srat_64.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -461,7 +461,8 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 		 * node, it must now point to the fake node ID.
 		 */
 		for (j = 0; j < MAX_LOCAL_APIC; j++)
-			if (apicid_to_node[j] == nid)
+			if (apicid_to_node[j] == nid &&
+			    fake_apicid_to_node[j] == NUMA_NO_NODE)
 				fake_apicid_to_node[j] = i;
 	}
 	for (i = 0; i < num_nodes; i++)
