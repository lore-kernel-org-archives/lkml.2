Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab1FAINo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:13:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:43645 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab1FAINm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:13:42 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:48 2011
Message-Id: <20110601080347.694529002@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:19 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Chang <dchang@novell.com>, Arjan Mels <arjan.mels@gmx.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [083/146] staging: usbip: fix wrong endian conversion
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -709,7 +709,7 @@ static void correct_endian_ret_submit(st
 		be32_to_cpus(&pdu->status);
 		be32_to_cpus(&pdu->actual_length);
 		be32_to_cpus(&pdu->start_frame);
-		cpu_to_be32s(&pdu->number_of_packets);
+		be32_to_cpus(&pdu->number_of_packets);
 		be32_to_cpus(&pdu->error_count);
 	}
 }


