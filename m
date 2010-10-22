Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215Ab0JVTZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:25:39 -0400
Received: from kroah.org ([198.145.64.141]:33882 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759170Ab0JVSzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:55:52 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:28 2010
Message-Id: <20101022185227.938836673@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Samu Onkalo <samu.p.onkalo@nokia.com>, Takashi Iwai <tiwai@suse.de>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [007/103] hwmon: (lis3) Fix Oops with NULL platform data
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit f7c77a3dc4683659b6f0d1b6cbc82b6253d095e0 upstream.

The recent addition of threaded irq handler causes a NULL dereference
when used with hp_accel driver, which has NULL pdata.

Acked-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/lis3lv02d.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -277,7 +277,7 @@ static irqreturn_t lis302dl_interrupt(in
 	wake_up_interruptible(&lis3_dev.misc_wait);
 	kill_fasync(&lis3_dev.async_queue, SIGIO, POLL_IN);
 out:
-	if (lis3_dev.whoami == WAI_8B && lis3_dev.idev &&
+	if (lis3_dev.pdata && lis3_dev.whoami == WAI_8B && lis3_dev.idev &&
 	    lis3_dev.idev->input->users)
 		return IRQ_WAKE_THREAD;
 	return IRQ_HANDLED;
@@ -718,7 +718,7 @@ int lis3lv02d_init_device(struct lis3lv0
 	 * io-apic is not configurable (and generates a warning) but I keep it
 	 * in case of support for other hardware.
 	 */
-	if (dev->whoami == WAI_8B)
+	if (dev->pdata && dev->whoami == WAI_8B)
 		thread_fn = lis302dl_interrupt_thread1_8b;
 	else
 		thread_fn = NULL;


