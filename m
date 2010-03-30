Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab0C3XrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:47:22 -0400
Received: from kroah.org ([198.145.64.141]:45979 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932511Ab0C3XT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:57 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:51 2010
Message-Id: <20100330224751.029615420@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tilman Schmidt <tilman@imap.cc>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [048/156] gigaset: correct range checking off by one error
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit 6ad34145cf809384359fe513481d6e16638a57a3 upstream.

Correct a potential array overrun due to an off by one error in the
range check on the CAPI CONNECT_REQ CIPValue parameter.
Found and reported by Dan Carpenter using smatch.

Impact: bugfix
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/gigaset/capi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -1313,7 +1313,7 @@ static void do_connect_req(struct gigase
 	}
 
 	/* check parameter: CIP Value */
-	if (cmsg->CIPValue > ARRAY_SIZE(cip2bchlc) ||
+	if (cmsg->CIPValue >= ARRAY_SIZE(cip2bchlc) ||
 	    (cmsg->CIPValue > 0 && cip2bchlc[cmsg->CIPValue].bc == NULL)) {
 		dev_notice(cs->dev, "%s: unknown CIP value %d\n",
 			   "CONNECT_REQ", cmsg->CIPValue);


