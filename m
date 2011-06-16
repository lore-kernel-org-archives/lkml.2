Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab1FPH1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:27:35 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:52216 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756334Ab1FPHFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:05:22 -0400
X-Sasl-enc: 4XiE2w+DKNk/aec0DoOYsG/uKzkrI71YBp7o8rQ/nEhv 1308207921
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:16:10 2011
Message-Id: <20110616001610.792770595@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:15:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: [15/91] [SCSI] Fix Ultrastor asm snippet
In-Reply-To: <20110616001900.GA25375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit fad4dab5e44e10acf6b0235e469cb8e773b58e31 upstream.

Commit 1292500b replaced

"=m" (*field) : "1" (*field)

with

"=m" (*field) :

with comment "The following patch fixes it by using the '+' operator on
the (*field) operand, marking it as read-write to gcc."
'+' was actually forgotten.  This really puts it.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: James Bottomley <jbottomley@parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/ultrastor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -306,7 +306,7 @@ static inline int find_and_clear_bit_16(
 	"0: bsfw %1,%w0\n\t"
 	"btr %0,%1\n\t"
 	"jnc 0b"
-	: "=&r" (rv), "=m" (*field) :);
+	: "=&r" (rv), "+m" (*field) :);
 
   return rv;
 }


