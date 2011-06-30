Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1F3Rbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 13:31:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21814 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab1F3Rbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 13:31:32 -0400
Date: Thu, 30 Jun 2011 10:31:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] media: fix radio-sf16fmr2 build when SND is not enabled
Message-Id: <20110630103104.0a5b8ce6.randy.dunlap@oracle.com>
In-Reply-To: <20110630165302.12ee1bd0.sfr@canb.auug.org.au>
References: <20110630165302.12ee1bd0.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090202.4E0CB2EB.00C8:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_SND is not enabled, radio-sf16fmr2 build fails with:

ERROR: "snd_tea575x_init" [drivers/media/radio/radio-sf16fmr2.ko] undefined!
ERROR: "snd_tea575x_exit" [drivers/media/radio/radio-sf16fmr2.ko] undefined!

so make this driver depend on SND.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
---
 drivers/media/radio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110630.orig/drivers/media/radio/Kconfig
+++ linux-next-20110630/drivers/media/radio/Kconfig
@@ -201,7 +201,7 @@ config RADIO_SF16FMI
 
 config RADIO_SF16FMR2
 	tristate "SF16FMR2 Radio"
-	depends on ISA && VIDEO_V4L2
+	depends on ISA && VIDEO_V4L2 && SND
 	---help---
 	  Choose Y here if you have one of these FM radio cards.
 
