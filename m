Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0IRSsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 14:48:41 -0400
Received: from kroah.org ([198.145.64.141]:38935 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab0IRSsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 14:48:36 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:46:21 2010
Message-Id: <20100918184621.234928485@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:45:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [04/11] irda: off by one
In-Reply-To: <20100918184651.GA14224@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit cf9b94f88bdbe8a02015fc30d7c232b2d262d4ad upstream.

This is an off by one.  We would go past the end when we NUL terminate
the "value" string at end of the function.  The "value" buffer is
allocated in irlan_client_parse_response() or
irlan_provider_parse_command().

CC: stable@kernel.org
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 net/irda/irlan/irlan_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/irda/irlan/irlan_common.c
+++ b/net/irda/irlan/irlan_common.c
@@ -1100,7 +1100,7 @@ int irlan_extract_param(__u8 *buf, char
 	memcpy(&val_len, buf+n, 2); /* To avoid alignment problems */
 	le16_to_cpus(&val_len); n+=2;
 
-	if (val_len > 1016) {
+	if (val_len >= 1016) {
 		IRDA_DEBUG(2, "%s(), parameter length to long\n", __func__ );
 		return -RSP_INVALID_COMMAND_FORMAT;
 	}


