Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2BEWgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:36:33 -0500
Received: from 1wt.eu ([62.212.114.60]:62095 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab2BEW04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:56 -0500
Message-Id: <20120205220951.162402426@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:29 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Anton Blanchard <anton@samba.org>, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 40/91] powerpc: pseries: Fix kexec on machines with more than 4TB of RAM
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit bed9a31527af8ff3dfbad62a1a42815cef4baab7 upstream.

On a box with 8TB of RAM the MMU hashtable is 64GB in size. That
means we have 4G PTEs. pSeries_lpar_hptab_clear was using a signed
int to store the index which will overflow at 2G.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/platforms/pseries/lpar.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/arch/powerpc/platforms/pseries/lpar.c
===================================================================
--- longterm-2.6.27.orig/arch/powerpc/platforms/pseries/lpar.c	2012-02-05 22:34:33.813915314 +0100
+++ longterm-2.6.27/arch/powerpc/platforms/pseries/lpar.c	2012-02-05 22:34:40.526914898 +0100
@@ -371,7 +371,7 @@
 		unsigned long ptel;
 	} ptes[4];
 	long lpar_rc;
-	int i, j;
+	unsigned long i, j;
 
 	/* Read in batches of 4,
 	 * invalidate only valid entries not in the VRMA


