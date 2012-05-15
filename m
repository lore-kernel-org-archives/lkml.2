Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965081Ab2EOCRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:14 -0400
Received: from mail1.windriver.com ([147.11.146.13]:52856 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964874Ab2EOCQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 017/179] staging: usbip: fix wrong endian conversion
Date: Mon, 14 May 2012 22:11:53 -0400
Message-ID: <1337048075-6132-18-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Chang <dchang@novell.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cacd18a8476ce145ca5dcd46dc5b75585fd1289c upstream.

Fix number_of_packets wrong endian conversion in function
correct_endian_ret_submit()

Signed-off-by: David Chang <dchang@novell.com>
Acked-by: Arjan Mels <arjan.mels@gmx.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/usbip/usbip_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 707b57d..c172ae9 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -689,7 +689,7 @@ static void correct_endian_ret_submit(struct usbip_header_ret_submit *pdu,
 		be32_to_cpus(&pdu->status);
 		be32_to_cpus(&pdu->actual_length);
 		be32_to_cpus(&pdu->start_frame);
-		cpu_to_be32s(&pdu->number_of_packets);
+		be32_to_cpus(&pdu->number_of_packets);
 		be32_to_cpus(&pdu->error_count);
 	}
 }
-- 
1.7.9.6

