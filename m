Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab0CaAUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:20:01 -0400
Received: from kroah.org ([198.145.64.141]:49212 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600Ab0C3XM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:57 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:53 2010
Message-Id: <20100330225853.461694959@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:58:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Martin Fuzzey <mfuzzey@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [72/89] V4L/DVB: Video : pwc : Fix regression in pwc_set_shutter_speed caused by bad 	constant => sizeof conversion.
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Martin Fuzzey <mfuzzey@gmail.com>

commit 53f68607caba85db9a73846ccd289e4b7fa96295 upstream.

Regression was caused by my commit 6b35ca0d3d586b8ecb8396821af21186e20afaf0
which determined message size using sizeof rather than hardcoded constants.

Unfortunately pwc_set_shutter_speed reuses a 2 byte buffer for a one byte
message too so the sizeof was bogus in this case.

All other uses of sizeof checked and are ok.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/pwc/pwc-ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/pwc/pwc-ctrl.c
+++ b/drivers/media/video/pwc/pwc-ctrl.c
@@ -753,7 +753,7 @@ int pwc_set_shutter_speed(struct pwc_dev
 		buf[0] = 0xff; /* fixed */
 
 	ret = send_control_msg(pdev,
-		SET_LUM_CTL, SHUTTER_MODE_FORMATTER, &buf, sizeof(buf));
+		SET_LUM_CTL, SHUTTER_MODE_FORMATTER, &buf, 1);
 
 	if (!mode && ret >= 0) {
 		if (value < 0)


