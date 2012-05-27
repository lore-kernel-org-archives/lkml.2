Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462Ab2E0BJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:09:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933412Ab2E0BJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:09:41 -0400
Message-Id: <20120527010430.537411175@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:11 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthias Fend <matthias.fend@wolfvision.net>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [ 48/94] USB: ffs-test: fix length argument of out function call
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Fend <Matthias.Fend@wolfvision.net>

commit eb9c5836384cd2a276254df6254ed71117983626 upstream.

The out functions should only handle actual available data instead of the complete buffer.
Otherwise for example the ep0_consume function will report ghost events since it tries to decode
the complete buffer - which may contain partly invalid data.

Signed-off-by: Matthias Fend <matthias.fend@wolfvision.net>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/usb/ffs-test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -324,7 +324,7 @@ static void *start_thread_helper(void *a
 
 		ret = t->in(t, t->buf, t->buf_size);
 		if (ret > 0) {
-			ret = t->out(t, t->buf, t->buf_size);
+			ret = t->out(t, t->buf, ret);
 			name = out_name;
 			op = "write";
 		} else {


