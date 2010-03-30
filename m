Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab0C3XVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:21:45 -0400
Received: from kroah.org ([198.145.64.141]:46267 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932416Ab0C3XUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:35 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:12 2010
Message-Id: <20100330224812.096158303@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Borislav Petkov <borislav.petkov@amd.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [080/156] edac, mce: Filter out invalid values
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit 5b89d2f9ace1970324facc68ca9b8fae19ce8096 upstream.

Print the CPU associated with the error only when the field is valid.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/edac/edac_mce_amd.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -316,7 +316,12 @@ void amd_decode_nb_mce(int node_id, stru
 		if (regs->nbsh & K8_NBSH_ERR_CPU_VAL)
 			pr_cont(", core: %u\n", (u8)(regs->nbsh & 0xf));
 	} else {
-		pr_cont(", core: %d\n", fls((regs->nbsh & 0xf) - 1));
+		u8 assoc_cpus = regs->nbsh & 0xf;
+
+		if (assoc_cpus > 0)
+			pr_cont(", core: %d", fls(assoc_cpus) - 1);
+
+		pr_cont("\n");
 	}
 
 	pr_emerg("%s.\n", EXT_ERR_MSG(xec));


