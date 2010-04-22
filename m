Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab0DVTzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:55:17 -0400
Received: from kroah.org ([198.145.64.141]:40846 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421Ab0DVT2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:35 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:14 2010
Message-Id: <20100422190914.637184780@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [081/197] libata: disable NCQ on Crucial C300 SSD
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 68b0ddb289220b6d4d865be128939663be34959d upstream.

Crucial said,

  Thank you for contacting us. We know that with our M225 line of SSDs
  you sometimes need to disable NCQ (native command queuing) to avoid
  just the type of errors you're seeing. Our recommendation for the
  M225 is to add libata.force=noncq to your Linux kernel boot options,
  under the kernel ATA library option.

  I have sent your feedback to the engineers working on the C300, and
  asked them to please pass it on to the firmware team. I have been
  notified that they are in the process of testing and finalizing a
  new firmware version, that you can expect to see released around the
  end of April. We’ll keep you posted as to when it will be available
  for download.

So, turn off NCQ on the drive w/ the current firmware revision.

Reported in the following bug.

  https://bugzilla.kernel.org/show_bug.cgi?id=15573

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: lethalwp@scarlet.be
Reported-by: Luke Macken <lmacken@redhat.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4348,6 +4348,9 @@ static const struct ata_blacklist_entry
 	{ "HTS541080G9SA00",    "MB4OC60D",     ATA_HORKAGE_NONCQ, },
 	{ "HTS541010G9SA00",    "MBZOC60D",     ATA_HORKAGE_NONCQ, },
 
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=15573 */
+	{ "C300-CTFDDAC128MAG",	"0001",		ATA_HORKAGE_NONCQ, },
+
 	/* devices which puke on READ_NATIVE_MAX */
 	{ "HDS724040KLSA80",	"KFAOA20N",	ATA_HORKAGE_BROKEN_HPA, },
 	{ "WDC WD3200JD-00KLB0", "WD-WCAMR1130137", ATA_HORKAGE_BROKEN_HPA },


