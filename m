Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602Ab0GAWCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:02:39 -0400
Received: from kroah.org ([198.145.64.141]:33771 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab0GAVM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:12:57 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:48 2010
Message-Id: <20100701174247.955645965@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:41:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Larry Finger <Larry.Finger@lwfinger.net>
Subject: [018/200] staging: vt6655: Fix kernel BUG on driver wpa initialization
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit f65515275ea3e45fdcd0fb78455f542d6fdca086 upstream.

In http://bugzilla.novell.com/show_bug.cgi?id=597299, the vt6655 driver
generates a kernel BUG on a NULL pointer dereference at NULL. This problem
has been traced to a failure in the wpa_set_wpadev() routine. As the vt6656
driver does not call this routine, the vt6655 code is similarly set to skip
the call.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Richard Meek <osl2008@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/vt6655/device_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1090,11 +1090,13 @@ device_found1(struct pci_dev *pcid, cons
     }
 //2008-07-21-01<Add>by MikeLiu
 //register wpadev
+#if 0
    if(wpa_set_wpadev(pDevice, 1)!=0) {
      printk("Fail to Register WPADEV?\n");
         unregister_netdev(pDevice->dev);
         free_netdev(dev);
    }
+#endif
     device_print_info(pDevice);
     pci_set_drvdata(pcid, pDevice);
     return 0;


