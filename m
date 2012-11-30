Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992666Ab2K3S4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:56:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:58271 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992647Ab2K3S4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jiri Engelthaler <engycz@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 21/56] mtd: slram: invalid checking of absolute end address
Date: Fri, 30 Nov 2012 10:55:13 -0800
Message-Id: <20121130185120.442919211@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Engelthaler <engycz@gmail.com>

commit c36a7ff4578ab6294885aef5ef241aeec4cdb1f0 upstream.

Fixed parsing end absolute address.

Signed-off-by: Jiri Engelthaler <engycz@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/devices/slram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/devices/slram.c
+++ b/drivers/mtd/devices/slram.c
@@ -240,7 +240,7 @@ static int parse_cmdline(char *devname,
 
 	if (*(szlength) != '+') {
 		devlength = simple_strtoul(szlength, &buffer, 0);
-		devlength = handle_unit(devlength, buffer) - devstart;
+		devlength = handle_unit(devlength, buffer);
 		if (devlength < devstart)
 			goto err_out;
 


