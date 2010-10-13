Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab0JMULN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 16:11:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62947 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab0JMULM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 16:11:12 -0400
Date: Wed, 13 Oct 2010 13:10:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>
Cc: gregkh@suse.de, akpm <akpm@linux-foundation.org>, speakup@braille.uwo.ca
Subject: [PATCH -next] staging/speakup: fix printk format warning
Message-Id: <20101013131049.912cb385.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

drivers/staging/speakup/serialio.c:44: warning: format '%x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: speakup@braille.uwo.ca
---
 drivers/staging/speakup/serialio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20101012.orig/drivers/staging/speakup/serialio.c
+++ linux-next-20101012/drivers/staging/speakup/serialio.c
@@ -41,7 +41,7 @@ struct serial_state *spk_serial_init(int
 		__release_region(&ioport_resource, ser->port, 8);
 		err = synth_request_region(ser->port, 8);
 		if (err) {
-			pr_warn("Unable to allocate port at %x, errno %i", ser->port, err);
+			pr_warn("Unable to allocate port at %lx, errno %i", ser->port, err);
 			return NULL;
 		}
 	}
