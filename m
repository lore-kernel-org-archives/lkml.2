Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab0KSWZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:25:45 -0500
Received: from kroah.org ([198.145.64.141]:45184 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475Ab0KSV6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:49 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:42 2010
Message-Id: <20101119215642.777198236@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [49/82] usb: r8a66597-hcd: Change mistake of the outsw function
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

commit ac9dfe9cdda4eb42ecaa9f13b0fee518e0b6518e upstream.

Some functions changed by 1c98347e613bf17ea2f18c9766ce0ab77f65a96d.
However, There was a change mistake of the function (outsw).

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
CC: Paul Mundt <lethal@linux-sh.org>
Acked-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/r8a66597.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/r8a66597.h
+++ b/drivers/usb/host/r8a66597.h
@@ -227,7 +227,7 @@ static inline void r8a66597_write_fifo(s
 		int odd = len & 0x0001;
 
 		len = len / 2;
-		ioread16_rep(fifoaddr, buf, len);
+		iowrite16_rep(fifoaddr, buf, len);
 		if (unlikely(odd)) {
 			buf = &buf[len];
 			iowrite8((unsigned char)*buf, fifoaddr);


