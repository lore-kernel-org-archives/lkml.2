Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab0LHCDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:03:13 -0500
Received: from kroah.org ([198.145.64.141]:48326 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779Ab0LHA7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:05 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:22 2010
Message-Id: <20101208005722.291898574@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Samuel Ortiz <samuel@sortiz.org>
Subject: [009/289] irda: Fix heap memory corruption in iriap.c
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Samuel Ortiz <samuel@sortiz.org>

commit 37f9fc452d138dfc4da2ee1ce5ae85094efc3606 upstream.

While parsing the GetValuebyClass command frame, we could potentially write
passed the skb->data pointer.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/irda/iriap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/irda/iriap.c
+++ b/net/irda/iriap.c
@@ -502,7 +502,8 @@ static void iriap_getvaluebyclass_confir
 		IRDA_DEBUG(4, "%s(), strlen=%d\n", __func__, value_len);
 
 		/* Make sure the string is null-terminated */
-		fp[n+value_len] = 0x00;
+		if (n + value_len < skb->len)
+			fp[n + value_len] = 0x00;
 		IRDA_DEBUG(4, "Got string %s\n", fp+n);
 
 		/* Will truncate to IAS_MAX_STRING bytes */


