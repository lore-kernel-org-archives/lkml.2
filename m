Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab0FAPRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 11:17:48 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37286 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab0FAPRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 11:17:46 -0400
Date: Tue, 1 Jun 2010 17:18:00 +0200
From: Borislav Petkov <bp@amd64.org>
To: mingo@elte.hu, norsk5@yahoo.com
Cc: hpa@zytor.com, tglx@linutronix.de, linux-edac@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: [PATCH 7/8] amd64_edac: Correct scrub rate setting
Message-ID: <20100601151800.GA12984@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275398971-12439-1-git-send-email-bp@amd64.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuliano_Meroni=2C?=
	=?iso-8859-1?Q?_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_La?=
	=?iso-8859-1?Q?ndkreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exit early when setting scrub rate on unknown/unsupported families.

Cc: stable@kernel.org
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 6866b98..71f5ce1 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -178,7 +178,7 @@ static int amd64_set_scrub_rate(struct mem_ctl_info *mci, u32 *bandwidth)
 
 	default:
 		amd64_printk(KERN_ERR, "Unsupported family!\n");
-		break;
+		return -EINVAL;
 	}
 	return amd64_search_set_scrub_rate(pvt->misc_f3_ctl, *bandwidth,
 			min_scrubrate);
-- 
1.7.1
