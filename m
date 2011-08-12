Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1HNQMg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:12:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab1HNQKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:10:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:59 2011
Message-Id: <20110812210559.224887970@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:05:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [81/90] powerpc: pseries: Fix kexec on machines with more than 4TB of RAM
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

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
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -395,7 +395,7 @@ static void pSeries_lpar_hptab_clear(voi
 		unsigned long ptel;
 	} ptes[4];
 	long lpar_rc;
-	int i, j;
+	unsigned long i, j;
 
 	/* Read in batches of 4,
 	 * invalidate only valid entries not in the VRMA


