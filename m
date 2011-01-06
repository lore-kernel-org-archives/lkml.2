Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1AFAk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:40:59 -0500
Received: from kroah.org ([198.145.64.141]:35969 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab1AFAbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:05 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:07 2011
Message-Id: <20110106002307.279243867@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ken Mills <ken.k.mills@intel.com>, Alan Cox <alan@linux.intel.com>
Subject: [111/152] n_gsm: Fix message length handling when building header
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ken Mills <ken.k.mills@intel.com>

commit be7a7411d63ccad165d66fe8e0b11b2ee336159b upstream.

Fix message length handling when building header

When the message length is greater than 127, the length field in the header
is built incorrectly. According to the spec, when the length is less than 128
the length field is a single byte formatted as: bbbbbbb1. When it is greater
than 127 then the field is two bytes of the format: bbbbbbb0 bbbbbbbb.

Signed-off-by: Ken Mills <ken.k.mills@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/n_gsm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/n_gsm.c
+++ b/drivers/char/n_gsm.c
@@ -716,8 +716,8 @@ static void __gsm_data_queue(struct gsm_
 		if (msg->len < 128)
 			*--dp = (msg->len << 1) | EA;
 		else {
-			*--dp = (msg->len >> 6) | EA;
-			*--dp = (msg->len & 127) << 1;
+			*--dp = (msg->len >> 7);	/* bits 7 - 15 */
+			*--dp = (msg->len & 127) << 1;	/* bits 0 - 6 */
 		}
 	}
 


