Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab1GVOfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:35:21 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:47970 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754493Ab1GVOfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:35:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: LOXuxqcVM1nUsMpY0xes4KVSJOPu.dUuFJtG02WN5Zu6ljB
 B98p.nqlXxWom8Bbkn0xJWsMm0WmcU5V54IbUaWkHZXni2Fh3OKxL39NZU8H
 NZAplZ1SbQ_xMi_5DFYyZS5ehGI3ii6.WXKXUi4i5jCThl8W2KX8fdnQukt1
 ZG.MHr8MpBShkBAtoujLEQXUnnyqqW.wSyTLd.8gAOUJZ6l7_9qBCCsyRc_L
 zs.2gZGcpEZi4kkMEuAPBVjS1mWlHXcaLd44STHL27x_cU8dbF1Z.6wGp6VH
 glut2HxxcXVnSdM4GModUxKMuDzxt7_V.ZrLsC6_F5NcrAUC0
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 22 Jul 2011 09:35:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Rabin Vincent <rabin@rab.in>
cc: penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: "slub: Rework allocator fastpaths" and slub debugging
In-Reply-To: <alpine.DEB.2.00.1107211351250.3995@router.home>
Message-ID: <alpine.DEB.2.00.1107220933570.2707@router.home>
References: <20110721184436.GA7474@debian> <alpine.DEB.2.00.1107211351250.3995@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Subject: slub: When allocating a new slab also prep the first object

We need to branch to the debug code for the first object if we allocate
a new slab otherwise the first object will be marked wrongly as inactive.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-07-22 09:29:05.465576295 -0500
+++ linux-2.6/mm/slub.c	2011-07-22 09:29:55.345575976 -0500
@@ -2082,6 +2082,9 @@ new_slab:
 		stat(s, ALLOC_SLAB);
 		c->node = page_to_nid(page);
 		c->page = page;
+
+		if (kmem_cache_debug(s))
+			goto debug;
 		goto load_freelist;
 	}
 	if (!(gfpflags & __GFP_NOWARN) && printk_ratelimit())
