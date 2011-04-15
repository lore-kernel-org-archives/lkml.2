Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1DOUru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:47:50 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:41922 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750776Ab1DOUrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:47:48 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: xAt6TeUVM1k32Rlogz1g9PkcdxaHMK4HgZtUTGZmUQk63Cs
 0Mf9WgEvCNaxhR8wEqRsIdgv0yqd.XyJVl3L.4.pELtxuj5ZxOThNiPHH.hw
 q8znJZHJqdDl0O1izuH8CHhSnLh_heuZUuOnn8aLx.x4RaFp0i4Rnu3wiNJc
 jcVLKHuux99opGXCpHgD7q5e6HUwJkRcwHh5BoFN5JgjpzRBek3FG5TVdMzn
 tllZr9EZaQUsktUJqiDXex5qZWqlP6Em6G3qT7YKXqkrf0_OYzcCTC2hIrXt
 q1vvoYetAPkVD7qGpyKvSdROu4zrmC8idGRJORLHAu9ASmKEKSeGrmadrdZo
 .SYai7kGpu82S7ceKC52DQvSS
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110415204746.665957452@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Apr 2011 15:47:31 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Subject: [slubllv3 01/21] slub: Use NUMA_NO_NODE in get_partial
References: <20110415204730.326790555@linux.com>
Content-Disposition: inline; filename=use_numa_nonode
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A -1 was leftover during the conversion.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-04-15 14:27:58.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-04-15 14:28:18.000000000 -0500
@@ -1487,7 +1487,7 @@ static struct page *get_partial(struct k
 	int searchnode = (node == NUMA_NO_NODE) ? numa_node_id() : node;
 
 	page = get_partial_node(get_node(s, searchnode));
-	if (page || node != -1)
+	if (page || node != NUMA_NO_NODE)
 		return page;
 
 	return get_any_partial(s, flags);

