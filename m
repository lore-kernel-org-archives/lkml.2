Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab1GOQnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:43:07 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35823 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab1GOQnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:43:05 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 08/15] gma500: skip getting modes via DDC on Moorestown
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 15 Jul 2011 17:34:15 +0100
Message-ID: <20110715163408.28759.62807.stgit@localhost.localdomain>
In-Reply-To: <20110715163117.28759.14946.stgit@localhost.localdomain>
References: <20110715163117.28759.14946.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Octavian Purdila <octavian.purdila@intel.com>

Moorestown does not have a DDC bus, skip getting modes via DDC. This
fixes the following bug:

BUG: unable to handle kernel NULL pointer dereference at 00000010
IP: [<c1172ff7>] i2c_transfer+0x17/0xb0
*pde = 00000000
Oops: 0000 [#1]

Call Trace:
 [<c1153ae9>] drm_do_probe_ddc_edid+0x59/0x90
 [<c1153cb4>] drm_get_edid+0x24/0x250
 [<c11805d2>] psb_intel_ddc_get_modes+0x22/0x60
 [<c117fe11>] psb_intel_lvds_get_modes+0x21/0x80

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_intel_lvds.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index da6f5c8..53803b2 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -521,7 +521,8 @@ static int psb_intel_lvds_get_modes(struct drm_connector *connector)
 					psb_intel_output->mode_dev;
 	int ret = 0;
 
-	ret = psb_intel_ddc_get_modes(psb_intel_output);
+	if (!IS_MRST(dev))
+		ret = psb_intel_ddc_get_modes(psb_intel_output);
 
 	if (ret)
 		return ret;

