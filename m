Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966242Ab2C3VXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:23:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936018Ab2C3VXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:23:07 -0400
Message-Id: <20120330194851.176240871@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 125/175] [media] mxl111sf: fix error on stream stop in mxl111sf_ep6_streaming_ctrl()
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Krufky <mkrufky@linuxtv.org>

commit 3be5bb71fbf18f83cb88b54a62a78e03e5a4f30a upstream.

Remove unnecessary register access in mxl111sf_ep6_streaming_ctrl()

This code breaks driver operation in kernel 3.3 and later, although
it works properly in 3.2  Disable register access to 0x12 for now.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb/dvb-usb/mxl111sf.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/media/dvb/dvb-usb/mxl111sf.c
+++ b/drivers/media/dvb/dvb-usb/mxl111sf.c
@@ -351,15 +351,13 @@ static int mxl111sf_ep6_streaming_ctrl(s
 					      adap_state->ep6_clockphase,
 					      0, 0);
 		mxl_fail(ret);
+#if 0
 	} else {
 		ret = mxl111sf_disable_656_port(state);
 		mxl_fail(ret);
+#endif
 	}
 
-	mxl111sf_read_reg(state, 0x12, &tmp);
-	tmp &= ~0x04;
-	mxl111sf_write_reg(state, 0x12, tmp);
-
 	return ret;
 }
 


