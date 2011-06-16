Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab1FPH1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:27:09 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37731 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756433Ab1FPHF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:05:28 -0400
X-Sasl-enc: viyY6SpBr6S22/bkX1OA8//xge+cDIikfOmWn5yUdlix 1308207927
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:16:11 2011
Message-Id: <20110616001611.190066067@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:15:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Chang <dchang@novell.com>, Arjan Mels <arjan.mels@gmx.net>
Subject: [19/91] staging: usbip: fix wrong endian conversion
In-Reply-To: <20110616001900.GA25375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: David Chang <dchang@novell.com>

commit cacd18a8476ce145ca5dcd46dc5b75585fd1289c upstream.

Fix number_of_packets wrong endian conversion in function
correct_endian_ret_submit()

Signed-off-by: David Chang <dchang@novell.com>
Acked-by: Arjan Mels <arjan.mels@gmx.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/usbip_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -770,7 +770,7 @@ static void correct_endian_ret_submit(st
 		be32_to_cpus(&pdu->status);
 		be32_to_cpus(&pdu->actual_length);
 		be32_to_cpus(&pdu->start_frame);
-		cpu_to_be32s(&pdu->number_of_packets);
+		be32_to_cpus(&pdu->number_of_packets);
 		be32_to_cpus(&pdu->error_count);
 	}
 }


