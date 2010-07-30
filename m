Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797Ab0G3Ryl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:54:41 -0400
Received: from kroah.org ([198.145.64.141]:57781 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759694Ab0G3RyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:09 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:34 2010
Message-Id: <20100730175134.043845500@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yoichi Yuasa <yuasa@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [005/205] net/dccp: expansion of error code size
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Yoichi Yuasa <yuasa@linux-mips.org>

[ Upstream commit d9b52dc6fd1fbb2bad645cbc86a60f984c1cb179 ]

Because MIPS's EDQUOT value is 1133(0x46d).
It's larger than u8.

Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/dccp/input.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/dccp/input.c
+++ b/net/dccp/input.c
@@ -124,9 +124,9 @@ static int dccp_rcv_closereq(struct sock
 	return queued;
 }
 
-static u8 dccp_reset_code_convert(const u8 code)
+static u16 dccp_reset_code_convert(const u8 code)
 {
-	const u8 error_code[] = {
+	const u16 error_code[] = {
 	[DCCP_RESET_CODE_CLOSED]	     = 0,	/* normal termination */
 	[DCCP_RESET_CODE_UNSPECIFIED]	     = 0,	/* nothing known */
 	[DCCP_RESET_CODE_ABORTED]	     = ECONNRESET,
@@ -148,7 +148,7 @@ static u8 dccp_reset_code_convert(const
 
 static void dccp_rcv_reset(struct sock *sk, struct sk_buff *skb)
 {
-	u8 err = dccp_reset_code_convert(dccp_hdr_reset(skb)->dccph_reset_code);
+	u16 err = dccp_reset_code_convert(dccp_hdr_reset(skb)->dccph_reset_code);
 
 	sk->sk_err = err;
 


