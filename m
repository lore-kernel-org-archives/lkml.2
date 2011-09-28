Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507Ab1I1WuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:50:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933425Ab1I1WuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:50:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:50 2011
Message-Id: <20110928220149.944962765@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasily Averin <vvs@sw.ru>, Mark Salyzyn <mark_salyzyn@us.xyratex.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [233/244] [SCSI] aacraid: reset should disable MSI interrupt
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasily Averin <vvs@parallels.com>

commit d0efab26f89506387a1bde898556660e06d7eb15 upstream.

scsi reset on hardware with enabled MSI interrupts generates WARNING message

[11027.798722] aacraid: Host adapter abort request (0,0,0,0)
[11027.798814] aacraid: Host adapter reset request. SCSI hang ?
[11087.762237] aacraid: SCSI bus appears hung
[11135.082543] ------------[ cut here ]------------
[11135.082646] WARNING: at drivers/pci/msi.c:658 pci_enable_msi_block+0x251/0x290()

Signed-off-by: Vasily Averin <vvs@sw.ru>
Acked-by: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/aacraid/commsup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1283,6 +1283,8 @@ static int _aac_reset_adapter(struct aac
 	kfree(aac->queues);
 	aac->queues = NULL;
 	free_irq(aac->pdev->irq, aac);
+	if (aac->msi)
+		pci_disable_msi(aac->pdev);
 	kfree(aac->fsa_dev);
 	aac->fsa_dev = NULL;
 	quirks = aac_get_driver_ident(index)->quirks;


