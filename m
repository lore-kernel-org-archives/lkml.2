Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab1KILNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 06:13:30 -0500
Received: from server88-208-211-118.live-servers.net ([88.208.211.118]:7515
	"EHLO mail.redrat.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750875Ab1KILN3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 06:13:29 -0500
From: Andrew Vincer <Andrew.Vincer@redrat.co.uk>
CC: "mchehab@infradead.org" <mchehab@infradead.org>,
        "jarod@redhat.com" <jarod@redhat.com>,
        "error27@gmail.com" <error27@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Vincer <Andrew.Vincer@redrat.co.uk>
Subject: [PATCH 1/1] rc: Fix redrat3_transmit_ir to use unsigned
Thread-Topic: [PATCH 1/1] rc: Fix redrat3_transmit_ir to use unsigned
Thread-Index: Acye0ACanC04pvpyRP2RIEgK7PhOTA==
Date: Wed, 9 Nov 2011 11:13:26 +0000
Message-ID: <DA69C24DC634074E9591C2B60BFDBC1C741A90@CP5-3512.fh.redrat.co.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [86.163.49.213]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per 5588dc2, change arguments of redrat3_transmit_ir to unsigned
and update code to treat last arg as number of ints rather than
number of bytes

Signed-off-by: Andrew Vincer <andrew@redrat.co.uk>
---
 drivers/media/rc/redrat3.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 61287fc..5e571ac 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -905,12 +905,13 @@ static int redrat3_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 	return carrier;
 }
 
-static int redrat3_transmit_ir(struct rc_dev *rcdev, int *txbuf, u32 n)
+static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
+				unsigned count)
 {
 	struct redrat3_dev *rr3 = rcdev->priv;
 	struct device *dev = rr3->dev;
 	struct redrat3_signal_header header;
-	int i, j, count, ret, ret_len, offset;
+	int i, j, ret, ret_len, offset;
 	int lencheck, cur_sample_len, pipe;
 	char *buffer = NULL, *sigdata = NULL;
 	int *sample_lens = NULL;
@@ -928,7 +929,6 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, int *txbuf, u32 n)
 		return -EAGAIN;
 	}
 
-	count = n / sizeof(int);
 	if (count > (RR3_DRIVER_MAXLENS * 2))
 		return -EINVAL;
 
@@ -1055,7 +1055,7 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, int *txbuf, u32 n)
 	if (ret < 0)
 		dev_err(dev, "Error: control msg send failed, rc %d\n", ret);
 	else
-		ret = n;
+		ret = count;
 
 out:
 	kfree(sample_lens);
-- 
1.7.1
