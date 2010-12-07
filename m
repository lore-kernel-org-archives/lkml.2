Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab0LGSus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 13:50:48 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:45854 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab0LGSuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 13:50:46 -0500
Date: Tue, 7 Dec 2010 10:50:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next v2] media: fix em28xx build, needs hardirq.h
Message-Id: <20101207105009.7d634c7b.randy.dunlap@oracle.com>
In-Reply-To: <20101207184453.GA30998@core2.telecom.by>
References: <20101206140055.34289498.sfr@canb.auug.org.au>
	<AANLkTi=XkxnHZGTEsrrRmPGQePitzb=akyS99_Qd6ROy@mail.gmail.com>
	<20101207103815.26054c38.randy.dunlap@oracle.com>
	<20101207184453.GA30998@core2.telecom.by>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It's defined in hardirq.h.

Yes, I was asleep at the wheel.  :(

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix em28xx build by adding hardirq.h header file:

drivers/media/video/em28xx/em28xx-vbi.c:49: error: implicit declaration of function 'in_interrupt'

Reported-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/em28xx/em28xx-vbi.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20101207.orig/drivers/media/video/em28xx/em28xx-vbi.c
+++ linux-next-20101207/drivers/media/video/em28xx/em28xx-vbi.c
@@ -23,6 +23,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/hardirq.h>
 #include <linux/init.h>
 
 #include "em28xx.h"
