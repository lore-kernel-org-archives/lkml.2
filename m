Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2E1DnK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:43:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52076 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754024Ab2E1D3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:35 -0400
Message-Id: <20120528031209.661692352@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:51 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthias Fend <Matthias.Fend@wolfvision.net>,
        Matthias Fend <matthias.fend@wolfvision.net>,
        Michal Nazarewicz <mina86@mina86.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 049/117] USB: ffs-test: fix length argument of out function call
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Fend <Matthias.Fend@wolfvision.net>

commit eb9c5836384cd2a276254df6254ed71117983626 upstream.

The out functions should only handle actual available data instead of the complete buffer.
Otherwise for example the ep0_consume function will report ghost events since it tries to decode
the complete buffer - which may contain partly invalid data.

Signed-off-by: Matthias Fend <matthias.fend@wolfvision.net>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/usb/ffs-test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index 4b107b5..8674b9e 100644
--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -297,7 +297,7 @@ static void *start_thread_helper(void *arg)
 
 		ret = t->in(t, t->buf, t->buf_size);
 		if (ret > 0) {
-			ret = t->out(t, t->buf, t->buf_size);
+			ret = t->out(t, t->buf, ret);
 			name = out_name;
 			op = "write";
 		} else {


