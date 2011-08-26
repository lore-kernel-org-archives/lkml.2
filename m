Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1H0O5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:57:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab1H0O5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:57:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 15:04:19 2011
Message-Id: <20110826220419.152931829@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 15:03:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Maxim A. Nikulin" <M.A.Nikulin@gmail.com>
Subject: [03/20] USB: assign instead of equal in usbtmc.c
In-Reply-To: <20110826220431.GA15382@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -267,7 +267,7 @@ usbtmc_abort_bulk_in_status:
 				dev_err(dev, "usb_bulk_msg returned %d\n", rv);
 				goto exit;
 			}
-		} while ((actual = max_size) &&
+		} while ((actual == max_size) &&
 			 (n < USBTMC_MAX_READS_TO_CLEAR_BULK_IN));
 
 	if (actual == max_size) {


