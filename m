Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946866Ab2ERXK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:10:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58844 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946744Ab2ERXH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:07:28 -0400
Message-Id: <20120518212652.917821752@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:27:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [ 41/47] i2c-eg20t: change timeout value 50msec to 1000msec
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit 8a52f9f347da721b199b7f9dcc0168bbe7d0baae upstream.

Currently, during i2c works alone, wait-event timeout is not occurred.
However, as CPU load increases, timeout occurs frequently.
So, I modified like this patch.
Modifying like this patch, I've never seen the timeout event with high
load test.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-eg20t.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -318,7 +318,7 @@ static s32 pch_i2c_wait_for_xfer_complet
 {
 	long ret;
 	ret = wait_event_timeout(pch_event,
-			(adap->pch_event_flag != 0), msecs_to_jiffies(50));
+			(adap->pch_event_flag != 0), msecs_to_jiffies(1000));
 
 	if (ret == 0) {
 		pch_err(adap, "timeout: %x\n", adap->pch_event_flag);


