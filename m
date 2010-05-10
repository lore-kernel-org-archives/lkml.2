Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab0EJXBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:01:01 -0400
Received: from kroah.org ([198.145.64.141]:51704 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932879Ab0EJW6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:00 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:38 2010
Message-Id: <20100510223538.195128270@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christian Lamparter <chunkeey@googlemail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [42/98] p54pci: fix bugs in p54p_check_tx_ring
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 0250ececdf6813457c98719e2d33b3684881fde0 upstream.

Hans de Goede identified a bug in p54p_check_tx_ring:

there are two ring indices. 1 => tx data and 3 => tx management.
But the old code had a constant "1" and this resulted in spurious
dma unmapping failures.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=583623
Bug-Identified-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -237,7 +237,7 @@ static void p54p_check_tx_ring(struct ie
 	u32 idx, i;
 
 	i = (*index) % ring_limit;
-	(*index) = idx = le32_to_cpu(ring_control->device_idx[1]);
+	(*index) = idx = le32_to_cpu(ring_control->device_idx[ring_index]);
 	idx %= ring_limit;
 
 	while (i != idx) {


