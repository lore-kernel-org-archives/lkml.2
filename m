Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab2HQAP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 20:15:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40813 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab2HQAPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 20:15:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Simon Budig <simon.budig@kernelconcepts.de>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Date: Thu, 16 Aug 2012 17:15:16 -0700
Message-ID: <87k3wy1ii3.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18VNwK9eJM9cR8D7EIUrnNszqAwxfbuIOY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0070]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Simon Budig <simon.budig@kernelconcepts.de>
X-Spam-Relay-Country: 
Subject: [PATCH] Input: Let the FT5x06 driver build without debugfs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When testing to make certain my user namespace code works
in various configurations I tripped over the tf5x06.c not
building with debugfs disabled.

drivers/input/touchscreen/edt-ft5x06.c: In function ‘edt_ft5x06_ts_remove’:
drivers/input/touchscreen/edt-ft5x06.c:846:14: error: ‘struct edt_ft5x06_ts_data’ has no member named ‘raw_buffer’

Fix the build by placing an #ifdef around the problem kfree.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/input/touchscreen/edt-ft5x06.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
index 9afc777..bc160b3 100644
--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -843,7 +843,9 @@ static int __devexit edt_ft5x06_ts_remove(struct i2c_client *client)
 	if (gpio_is_valid(pdata->reset_pin))
 		gpio_free(pdata->reset_pin);
 
+#if defined(CONFIG_DEBUG_FS)
 	kfree(tsdata->raw_buffer);
+#endif
 	kfree(tsdata);
 
 	return 0;
-- 
1.7.5.4

