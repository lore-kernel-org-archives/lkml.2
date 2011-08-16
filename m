Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab1HPCwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:52:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab1HPCwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:52:14 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Mon Aug 15 19:44:53 2011
Message-Id: <20110816024453.109265838@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 15 Aug 2011 19:42:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Maxim A. Nikulin" <M.A.Nikulin@gmail.com>
Subject: [06/26] USB: assign instead of equal in usbtmc.c
In-Reply-To: <20110816024553.GA5631@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maxim Nikulin <m.a.nikulin@gmail.com>

commit 4f1a7a3e78037721496283ea3e87cfefc64d99c7 upstream.

Assign operator instead of equality test in the usbtmc_ioctl_abort_bulk_in() function.

Signed-off-by: Maxim A. Nikulin <M.A.Nikulin@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/usbtmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -268,7 +268,7 @@ usbtmc_abort_bulk_in_status:
 				dev_err(dev, "usb_bulk_msg returned %d\n", rv);
 				goto exit;
 			}
-		} while ((actual = max_size) &&
+		} while ((actual == max_size) &&
 			 (n < USBTMC_MAX_READS_TO_CLEAR_BULK_IN));
 
 	if (actual == max_size) {


