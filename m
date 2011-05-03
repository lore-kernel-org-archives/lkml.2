Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1ECQzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:55:45 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45625 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab1ECQw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:52:56 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 12:52:53 EDT
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 11/23] intel_sst: Enable recording via DMIC
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:33:59 +0100
Message-ID: <20110503163354.24853.61937.stgit@bob.linux.org.uk>
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

We may need to make some of this board specific eventually

Signed-off-by: Lu Guanqun <guanqun.lu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intelmid_v2_control.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/drivers/staging/intel_sst/intelmid_v2_control.c b/drivers/staging/intel_sst/intelmid_v2_control.c
index cae7bc2..3d90f45 100644
--- a/drivers/staging/intel_sst/intelmid_v2_control.c
+++ b/drivers/staging/intel_sst/intelmid_v2_control.c
@@ -881,12 +881,12 @@ static int nc_set_selected_input_dev(u8 value)
 		sc_access[2].reg_addr = 0x10a;
 		sc_access[2].value = 0x40;
 		sc_access[2].mask = MASK6;
-		sc_access[3].reg_addr = 0x109;
+		sc_access[3].reg_addr = LILSEL;
 		sc_access[3].mask = MASK6;
 		sc_access[3].value = 0x00;
-		sc_access[4].reg_addr = 0x104;
-		sc_access[4].value = 0x3C;
-		sc_access[4].mask = 0xff;
+		sc_access[4].reg_addr = ADCSAMPLERATE;
+		sc_access[4].mask =  MASK7|MASK6|MASK5|MASK4|MASK3;
+		sc_access[4].value = 0x33;
 		num_val = 5;
 		break;
 	default:

