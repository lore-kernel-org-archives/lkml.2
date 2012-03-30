Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936021Ab2C3VXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:23:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966282Ab2C3VW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:22:58 -0400
Message-Id: <20120330194850.378974131@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Ji=C5=99=C3=AD=20Zelenka?= <klacek@bubakov.net>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 122/175] [media] tda10071: fix the delivery system
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit 2b49fad59513b07f976c9711b99f93ae74d081c5 upstream.

Commit b2a29b578d9c21b2e5c88020f830d3c42115c51d sets accidentally
supported delivery systems as DVB-T/T2 whilst it should be
DVB-S/S2. Due to that frontend cannot be used at all.

Reported-by: Jiří Zelenka <klacek@bubakov.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb/frontends/tda10071.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb/frontends/tda10071.c
+++ b/drivers/media/dvb/frontends/tda10071.c
@@ -1215,7 +1215,7 @@ error:
 EXPORT_SYMBOL(tda10071_attach);
 
 static struct dvb_frontend_ops tda10071_ops = {
-	.delsys = { SYS_DVBT, SYS_DVBT2 },
+	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "NXP TDA10071",
 		.frequency_min = 950000,


