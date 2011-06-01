Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162641Ab1FAIWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:22:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162615Ab1FAIWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:22:33 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:40 2011
Message-Id: <20110601081139.963822896@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:54 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Chang <dchang@novell.com>, Arjan Mels <arjan.mels@gmx.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [084/165] staging: usbip: fix wrong endian conversion
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 806
Lines: 27

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
@@ -604,7 +604,7 @@ static void correct_endian_ret_submit(st
 		be32_to_cpus(&pdu->status);
 		be32_to_cpus(&pdu->actual_length);
 		be32_to_cpus(&pdu->start_frame);
-		cpu_to_be32s(&pdu->number_of_packets);
+		be32_to_cpus(&pdu->number_of_packets);
 		be32_to_cpus(&pdu->error_count);
 	}
 }


