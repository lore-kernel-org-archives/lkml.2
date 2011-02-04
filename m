Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab1BDMXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:23:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab1BDMXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:23:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=wmHg4q0FTsuMLglewYrLIThhznsldfAt5C7PWL7dyggzK90lo8Dfa4Jbm9qaGdqWZK
         ZzM/ZJMZXXlFoCSHDgrsQKi9KIpwgtPD//zmFwxMQQcIkQzVjjOkycjaTnkY9lMSlGGn
         TNwtYdEF9X9LydPjWY2cjUpBTESYpq/CekBH8=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 01/20] mach-omap2: mux: world-writable debugfs files
Date: Fri,  4 Feb 2011 15:23:13 +0300
Message-Id: <1aa2fe44c18b9f24eb52a1be98d017f1f568e6bb.1296818921.git.segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not create mux debugfs files as world-writable.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Cannot compile the driver, so it is not tested at all.

 arch/arm/mach-omap2/mux.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index 98148b6..6c84659 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -605,7 +605,7 @@ static void __init omap_mux_dbg_create_entry(
 	list_for_each_entry(e, &partition->muxmodes, node) {
 		struct omap_mux *m = &e->mux;
 
-		(void)debugfs_create_file(m->muxnames[0], S_IWUGO, mux_dbg_dir,
+		(void)debugfs_create_file(m->muxnames[0], S_IWUSR, mux_dbg_dir,
 					  m, &omap_mux_dbg_signal_fops);
 	}
 }
-- 
1.7.0.4

