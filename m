Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966129Ab2C3VV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:21:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966076Ab2C3VVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:21:48 -0400
Message-Id: <20120330194845.036618607@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 099/175] pata_legacy: correctly mask recovery field for HT6560B
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 9716387311c790de381214c03e7f1b72b91a8189 upstream.

According to the HT6560H datasheet, the recovery timing field is 4-bit wide,
with a value of 0 meaning 16 cycles. Correct obvious thinko in the recovery
field mask.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/pata_legacy.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -401,8 +401,7 @@ static void ht6560b_set_piomode(struct a
 	ata_timing_compute(adev, adev->pio_mode, &t, 20000, 1000);
 
 	active = clamp_val(t.active, 2, 15);
-	recover = clamp_val(t.recover, 2, 16);
-	recover &= 0x15;
+	recover = clamp_val(t.recover, 2, 16) & 0x0F;
 
 	inb(0x3E6);
 	inb(0x3E6);


