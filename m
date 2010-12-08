Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0LHBMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:12:15 -0500
Received: from kroah.org ([198.145.64.141]:33793 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932797Ab0LHBDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:45 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:46 2010
Message-Id: <20101208005746.574069911@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Taht <d@teklibre.com>
Subject: [252/289] Staging: frontier: fix up some sysfs attribute permissions
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 3bad28ec006ad6ab2bca4e5103860b75391e3c9d and
2a767fda5d0d8dcff465724dfad6ee131489b3f2 upstream merged together.

They should not be writable by any user

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Taht <d@teklibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/frontier/tranzport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -204,7 +204,7 @@ static void usb_tranzport_abort_transfer
     t->value = temp;							\
     return count;							\
   }									\
-  static DEVICE_ATTR(value, S_IWUGO | S_IRUGO, show_##value, set_##value);
+  static DEVICE_ATTR(value, S_IWUSR | S_IRUGO, show_##value, set_##value);
 
 show_int(enable);
 show_int(offline);


