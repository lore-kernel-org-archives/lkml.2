Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab0CaAEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:04:12 -0400
Received: from kroah.org ([198.145.64.141]:45304 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932224Ab0C3XSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:34 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:48 2010
Message-Id: <20100330225647.623319101@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Borislav Petkov <borislav.petkov@amd.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [076/116] edac, mce: Filter out invalid values
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit 5b89d2f9ace1970324facc68ca9b8fae19ce8096 upstream.

Print the CPU associated with the error only when the field is valid.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/edac/edac_mce_amd.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -311,9 +311,13 @@ void amd_decode_nb_mce(int node_id, stru
 		if (regs->nbsh & K8_NBSH_ERR_CPU_VAL)
 			pr_cont(", core: %u\n", (u8)(regs->nbsh & 0xf));
 	} else {
-		pr_cont(", core: %d\n", ilog2((regs->nbsh & 0xf)));
-	}
+		u8 assoc_cpus = regs->nbsh & 0xf;
+
+		if (assoc_cpus > 0)
+			pr_cont(", core: %d", fls(assoc_cpus) - 1);
 
+		pr_cont("\n");
+	}
 
 	pr_emerg("%s.\n", EXT_ERR_MSG(xec));
 


