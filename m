Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965886Ab2KBKXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:23:51 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:48543 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965871Ab2KBKXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:23:49 -0400
Date: Fri, 2 Nov 2012 11:23:35 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Michal Marek <mmarek@suse.cz>, David Gibson <david@gibson.dropbear.id.au>,
        Jon Loeliger <jdl@jdl.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-arch@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, linux-mips@linux-mips.org
Subject: Re: [PATCH V5 1/2] kbuild: centralize .dts->.dtb rule
Message-ID: <20121102102335.GF2905@linux-mips.org>
References: <1351721431-26220-1-git-send-email-swarren@wwwdotorg.org>
 <20121102095801.GC17860@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121102095801.GC17860@linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 10:58:01AM +0100, Ralf Baechle wrote:

> Can you fold these MIPS bits into your patch?

I missed Lantiq.

  Ralf

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 arch/mips/cavium-octeon/Makefile | 3 ---
 arch/mips/lantiq/dts/Makefile    | 3 ---
 arch/mips/netlogic/dts/Makefile  | 3 ---
 3 files changed, 9 deletions(-)

diff --git a/arch/mips/cavium-octeon/Makefile b/arch/mips/cavium-octeon/Makefile
index bc96e29..6e927cf 100644
--- a/arch/mips/cavium-octeon/Makefile
+++ b/arch/mips/cavium-octeon/Makefile
@@ -24,9 +24,6 @@ DTB_FILES = $(patsubst %.dts, %.dtb, $(DTS_FILES))
 
 obj-y += $(patsubst %.dts, %.dtb.o, $(DTS_FILES))
 
-$(obj)/%.dtb: $(src)/%.dts FORCE
-	$(call if_changed_dep,dtc)
-
 # Let's keep the .dtb files around in case we want to look at them.
 .SECONDARY:  $(addprefix $(obj)/, $(DTB_FILES))
 
diff --git a/arch/mips/lantiq/dts/Makefile b/arch/mips/lantiq/dts/Makefile
index 674fca4..6fa72dd 100644
--- a/arch/mips/lantiq/dts/Makefile
+++ b/arch/mips/lantiq/dts/Makefile
@@ -1,4 +1 @@
 obj-$(CONFIG_DT_EASY50712) := easy50712.dtb.o
-
-$(obj)/%.dtb: $(obj)/%.dts
-	$(call if_changed,dtc)
diff --git a/arch/mips/netlogic/dts/Makefile b/arch/mips/netlogic/dts/Makefile
index 67ae3fe2..d117d46 100644
--- a/arch/mips/netlogic/dts/Makefile
+++ b/arch/mips/netlogic/dts/Makefile
@@ -1,4 +1 @@
 obj-$(CONFIG_DT_XLP_EVP) := xlp_evp.dtb.o
-
-$(obj)/%.dtb: $(obj)/%.dts
-	$(call if_changed,dtc)
