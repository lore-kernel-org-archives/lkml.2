Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1GHI6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:58:46 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33119 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1GHI6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:58:42 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] sst: report correct jack event
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 08 Jul 2011 09:59:10 +0100
Message-ID: <20110708085856.18212.35505.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lu Guanqun <guanqun.lu@intel.com>

The status of jack event is compared bitwise:

[in sound/core/jack.c:snd_jack_report()]
	for (i = 0; i < ARRAY_SIZE(jack_switch_types); i++) {
		int testbit = 1 << i;
		if (jack->type & testbit)
			input_report_switch(jack->input_dev,
					    jack_switch_types[i],
					    status & testbit);
	}

So in order to report the correct events, 3 should be passed instead of 1.

Signed-off-by: Lu Guanqun <guanqun.lu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intelmid_v2_control.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/staging/intel_sst/intelmid_v2_control.c b/drivers/staging/intel_sst/intelmid_v2_control.c
index 000378a..46ab55e 100644
--- a/drivers/staging/intel_sst/intelmid_v2_control.c
+++ b/drivers/staging/intel_sst/intelmid_v2_control.c
@@ -1090,7 +1090,7 @@ static void nc_pmic_irq_cb(void *cb_data, u8 intsts)
 	if (intsts & 0x1) {
 		pr_debug("SST DBG:MAD headset detected\n");
 		/* send headset detect/undetect */
-		present = (value == 0x1) ? 1 : 0;
+		present = (value == 0x1) ? 3 : 0;
 		jack_event_flag = 1;
 		mjack->jack.type = SND_JACK_HEADSET;
 		hp_automute(SND_JACK_HEADSET, present);

