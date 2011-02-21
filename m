Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1BUOlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:41:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290Ab1BUOls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:41:48 -0500
Date: Mon, 21 Feb 2011 15:41:46 +0100
From: David Sterba <dsterba@suse.cz>
To: mchehab@redhat.com
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Sterba <dsterba@suse.cz>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH][RESEND] i7core_edac: fix misuse of logical operation in
 place of bitop
Message-ID: <20110221144146.GE5766@ds.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 1.7.3.4.578.g6068a
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---

Hi Mauro, this fix has not been applied yet, can you please pick it up?

Thanks,
dave

 drivers/edac/i7core_edac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 362861c..f41a34e 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -731,7 +731,7 @@ static int get_dimm_config(const struct mem_ctl_info *mci)
 			debugf1("\t\t%#x\t%#x\t%#x\n",
 				(value[j] >> 27) & 0x1,
 				(value[j] >> 24) & 0x7,
-				(value[j] && ((1 << 24) - 1)));
+				(value[j] & ((1 << 24) - 1)));
 	}
 
 	return 0;
@@ -1670,7 +1670,7 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 	char *type, *optype, *err, *msg;
 	unsigned long error = m->status & 0x1ff0000l;
 	u32 optypenum = (m->status >> 4) & 0x07;
-	u32 core_err_cnt = (m->status >> 38) && 0x7fff;
+	u32 core_err_cnt = (m->status >> 38) & 0x7fff;
 	u32 dimm = (m->misc >> 16) & 0x3;
 	u32 channel = (m->misc >> 18) & 0x3;
 	u32 syndrome = m->misc >> 32;
-- 
1.7.3.4.578.g6068a

