Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965141Ab1C3VJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:09:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:38078 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965093Ab1C3VJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133795"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: pbruskispam@op.pl, tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [208/275] ALSA: ctxfi - Clear input settings before initialization
Message-Id: <20110330210732.B02703E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Przemyslaw Bruski <pbruskispam@op.pl>

commit efed5f26664f93991c929d5bb343e65f900d72bc upstream.

Clear input settings before initialization.

Signed-off-by: Przemyslaw Bruski <pbruskispam@op.pl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/ctxfi/ctdaio.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/sound/pci/ctxfi/ctdaio.c
===================================================================
--- linux-2.6.35.y.orig/sound/pci/ctxfi/ctdaio.c	2011-03-29 22:50:35.695345064 -0700
+++ linux-2.6.35.y/sound/pci/ctxfi/ctdaio.c	2011-03-29 23:03:02.594233790 -0700
@@ -176,6 +176,7 @@
 	if (!entry)
 		return -ENOMEM;
 
+	dao->ops->clear_left_input(dao);
 	/* Program master and conjugate resources */
 	input->ops->master(input);
 	daio->rscl.ops->master(&daio->rscl);
@@ -204,6 +205,7 @@
 	if (!entry)
 		return -ENOMEM;
 
+	dao->ops->clear_right_input(dao);
 	/* Program master and conjugate resources */
 	input->ops->master(input);
 	daio->rscr.ops->master(&daio->rscr);
