Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab1ECQxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:53:00 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45625 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab1ECQw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:52:58 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 12:52:53 EDT
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 09/23] intel_sst: Set de-bounce time
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:33:28 +0100
Message-ID: <20110503163324.24853.43871.stgit@bob.linux.org.uk>
In-Reply-To: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lu Guanqun <guanqun.lu@intel.com>

In order to make jack detection behave properly, we have to set
the de-bounce time, otherwise, some weird events happens:
e.g. no plug-out event seen.

Signed-off-by: Lu Guanqun <guanqun.lu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intelmid_v2_control.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)


diff --git a/drivers/staging/intel_sst/intelmid_v2_control.c b/drivers/staging/intel_sst/intelmid_v2_control.c
index 10762d7..48ef2fa 100644
--- a/drivers/staging/intel_sst/intelmid_v2_control.c
+++ b/drivers/staging/intel_sst/intelmid_v2_control.c
@@ -84,6 +84,7 @@ enum reg_v3 {
 	HPLMIXSEL = 0x12b,
 	HPRMIXSEL = 0x12c,
 	LOANTIPOP = 0x12d,
+	AUXDBNC = 0x12f,
 };
 
 /****
@@ -860,7 +861,10 @@ static int nc_set_selected_input_dev(u8 value)
 		sc_access[3].reg_addr = 0x105;
 		sc_access[3].value = 0x40;
 		sc_access[3].mask = MASK6;
-		num_val = 4;
+		sc_access[4].reg_addr = AUXDBNC;
+		sc_access[4].mask = MASK7|MASK6|MASK5|MASK4|MASK3|MASK2|MASK1|MASK0;
+		sc_access[4].value = 0xff;
+		num_val = 5;
 		break;
 
 	case DMIC:

