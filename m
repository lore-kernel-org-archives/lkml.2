Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab1LHWqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 17:46:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60931 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab1LHWqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 17:46:40 -0500
Date: Thu, 8 Dec 2011 14:46:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Subrata Modak <subrata@linux.vnet.ibm.com>,
        Manas k Nayak <maknayak@in.ibm.com>, Mark Wizner <markwiz@us.ibm.com>,
        Pavaman <pavsubra@in.ibm.com>, Naveed <naveedaus@in.ibm.com>,
        "divya.vikas" <divya.vikas@in.ibm.com>, Vishu <svishuku@in.ibm.com>
Subject: [patch] powerpc, mm: fix section mismatch for read_n_cells
In-Reply-To: <alpine.DEB.2.00.1112081428290.28693@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1112081443270.28693@chino.kir.corp.google.com>
References: <1323371433.23534.8.camel@subratamodak.linux.ibm.com> <alpine.DEB.2.00.1112081428290.28693@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read_n_cells() cannot be marked as .devinit.text since it is referenced 
from two functions that are not in that section: of_get_lmb_size() and 
hot_add_drconf_scn_to_nid().

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/powerpc/mm/numa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -406,7 +406,7 @@ static void __init get_n_mem_cells(int *n_addr_cells, int *n_size_cells)
 	of_node_put(memory);
 }
 
-static unsigned long __devinit read_n_cells(int n, const unsigned int **buf)
+static unsigned long read_n_cells(int n, const unsigned int **buf)
 {
 	unsigned long result = 0;
 
