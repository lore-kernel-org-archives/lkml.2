Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab2FMI2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:28:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27340 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2FMI2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:28:21 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-ec-4fd84f0bd881
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Liam Girdwood'" <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, sbkim01@gmail.com
Subject: [PATCH 3/5] regulator: Modify ramp_delay value for s5m8767a
Date: Wed, 13 Jun 2012 17:27:54 +0900
Message-id: <042101cd493e$6e2e9900$4a8bcb00$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1JPm4ITcdeO66nQNGL+AR6hnyIYg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAV1u/xv+BscOiVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MRyfnsRQ8YK/oPLOHsYFxNVsXIyeHhICJROetlVC2mMSFe+uB
	bC4OIYFFjBJrXh1lBUkICcxlkni8NAjEZhPQkFi5+y1Yg4hAmMTMWStZQGxmAWOJEwvfs4PY
	wgIuEq2TF4PFWQRUJTacaAOr5xUwlFjwsZMRwhaU+DH5HlSvlsT6nceZIGx5ic1r3jJ3MXIA
	HaQu8eivLsQqPYn3D05AlYhI7HvxjnECo8AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs81
	0itOzC0uzUvXS87P3cQIDstn0jsYVzVYHGIU4GBU4uENcrvhL8SaWFZcmXuIUYKDWUmEt3jr
	dX8h3pTEyqrUovz4otKc1OJDjNIcLErivE3WF/yFBNITS1KzU1MLUotgskwcnFINjOpHZY6+
	UVh/fMOFrQwX/eom7JxaULD+72Tma+1vFrcJTbp466C5oqqnqf2cn9OWSams+GghJ3/p2eE7
	kyuvHHhS9vfsk2+2jzbfuv1m3dwlr4NKgzYznV+UkvSY/xzH6xmXeKP9ds16bHNLLlRGJPH6
	3m2W1ofs7VYcuB9x1yZn8+Jf8z7P3cdoqcRSnJFoqMVcVJwIAJ+ghRlHAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As s5m8767a is revisioned, ramp_delay register is changed.
5mV/uS, 10mV/uS, 25mV/uS, 50mV/uS, 100mV/uS ramp delay can be selected.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/regulator/s5m8767.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index ce9dda2..924968a 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -681,9 +681,13 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 	if (s5m8767->buck2_ramp || s5m8767->buck3_ramp
 		|| s5m8767->buck4_ramp) {
 		switch (s5m8767->ramp_delay) {
-		case 15:
+		case 5:
 			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
-					0xc0, 0xf0);
+					0x40, 0xf0);
+			break;
+		case 10:
+			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
+					0x90, 0xf0);
 			break;
 		case 25:
 			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
-- 
1.7.1


