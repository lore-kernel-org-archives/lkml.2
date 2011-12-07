Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab1LGQU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:20:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757739Ab1LGQUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:20:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:16 2011
Message-Id: <20111207161216.260252820@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:20 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>,
        Santosh Shilimkar <santosh.shilimar@ti.com>,
        sricharan <r.sricharan@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
Subject: [018/104] ARM: OMAP: hwmod: Fix the addr space, irq, dma count APIs
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: sricharan <r.sricharan@ti.com>

commit cc1b0765da6078b906772b79ff211b88cc0ae958 upstream.

The address spaces, irqs and dma reqs count APIs return the
number of corresponding entries in a hwmod including a additional
null value or a -1 terminator in the structure introduced recently.
More information here:

- 212738a4: omap_hwmod: use a terminator record with omap_hwmod_mpu_irqs
  arrays

- 78183f3f: omap_hwmod: use a null structure record to terminate
  omap_hwmod_addr_space arrays

- bc614958: omap_hwmod: use a terminator record with omap_hwmod_dma_info
  arrays

The issue with irqs and dma info was originally reported by Benoit Cousson.

The devices which have multiple hwmods and use device_build_ss are
broken with this, as their resources are populated with a extra null
value, subsequently the probe fails. So fix the API not to include
the array terminator in the count.

Reported-by: Benoit Cousson <b-cousson@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimar@ti.com>
Signed-off-by: sricharan <r.sricharan@ti.com>
Signed-off-by: Benoit Cousson <b-cousson@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-omap2/omap_hwmod.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -749,7 +749,7 @@ static int _count_mpu_irqs(struct omap_h
 		ohii = &oh->mpu_irqs[i++];
 	} while (ohii->irq != -1);
 
-	return i;
+	return i-1;
 }
 
 /**
@@ -772,7 +772,7 @@ static int _count_sdma_reqs(struct omap_
 		ohdi = &oh->sdma_reqs[i++];
 	} while (ohdi->dma_req != -1);
 
-	return i;
+	return i-1;
 }
 
 /**
@@ -795,7 +795,7 @@ static int _count_ocp_if_addr_spaces(str
 		mem = &os->addr[i++];
 	} while (mem->pa_start != mem->pa_end);
 
-	return i;
+	return i-1;
 }
 
 /**


