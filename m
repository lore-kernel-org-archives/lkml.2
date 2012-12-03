Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab2LCOgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:36:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43799 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932250Ab2LCOgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:31 -0500
Message-Id: <20121203143154.493678464@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:36 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Engelthaler <engycz@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 50/89] mtd: slram: invalid checking of absolute end address
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Engelthaler <engycz@gmail.com>

commit c36a7ff4578ab6294885aef5ef241aeec4cdb1f0 upstream.

Fixed parsing end absolute address.

Signed-off-by: Jiri Engelthaler <engycz@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mtd/devices/slram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/slram.c b/drivers/mtd/devices/slram.c
index 8f52fc8..5a5cd2a 100644
--- a/drivers/mtd/devices/slram.c
+++ b/drivers/mtd/devices/slram.c
@@ -240,7 +240,7 @@ static int parse_cmdline(char *devname, char *szstart, char *szlength)
 
 	if (*(szlength) != '+') {
 		devlength = simple_strtoul(szlength, &buffer, 0);
-		devlength = handle_unit(devlength, buffer) - devstart;
+		devlength = handle_unit(devlength, buffer);
 		if (devlength < devstart)
 			goto err_out;
 


