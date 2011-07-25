Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab1GYQTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 12:19:34 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:34914 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751320Ab1GYQTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 12:19:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=HTGTNEvG6djOrPWjYFOWYctfKs1k3xe15TLBX6Myc3KWMnGhtYhPDex594XQoYhC7h0vQuJwwCVniE2pobRjEbge52z399gUc5ok1QjWJdVrYx9WRLf2nt/TEJQKKDCP;
Date: Mon, 25 Jul 2011 09:19:27 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, jorge@dti2.net,
        Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-watchdog@vger.kernel.org, akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] watchdog: fix it8712f_wdt build errors
Message-Id: <20110725091927.e154fd28.rdunlap@xenotime.net>
In-Reply-To: <20110725162542.39ea8d8cbd51604523635c1a@canb.auug.org.au>
References: <20110725162542.39ea8d8cbd51604523635c1a@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build errors by adding missing header file:

drivers/watchdog/it8712f_wdt.c:127: error: implicit declaration of function 'request_muxed_region'
drivers/watchdog/it8712f_wdt.c:141: error: implicit declaration of function 'release_region'
drivers/watchdog/it8712f_wdt.c:412: error: implicit declaration of function 'request_region'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/watchdog/it8712f_wdt.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110725.orig/drivers/watchdog/it8712f_wdt.c
+++ linux-next-20110725/drivers/watchdog/it8712f_wdt.c
@@ -31,6 +31,7 @@
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/ioport.h>
 
 #define NAME "it8712f_wdt"
 
