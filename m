Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223Ab1BPBHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:07:03 -0500
Received: from kroah.org ([198.145.64.141]:45813 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933127Ab1BPAt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:49:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:09 2011
Message-Id: <20110216002109.001004907@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 099/176] PCI: pci-stub: ignore zero-length id parameters
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 99a0fadf561e1f553c08f0a29f8b2578f55dd5f0 upstream.

pci-stub uses strsep() to separate list of ids and generates a warning
message when it fails to parse an id.  However, not specifying the
parameter results in ids set to an empty string.  strsep() happily
returns the empty string as the first token and thus triggers the
warning message spuriously.

Make the tokner ignore zero length ids.

Reported-by: Chris Wright <chrisw@sous-sol.org>
Reported-by: Prasad Joshi <P.G.Joshi@student.reading.ac.uk>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci-stub.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pci/pci-stub.c
+++ b/drivers/pci/pci-stub.c
@@ -54,6 +54,9 @@ static int __init pci_stub_init(void)
 			subdevice = PCI_ANY_ID, class=0, class_mask=0;
 		int fields;
 
+		if (!strlen(id))
+			continue;
+
 		fields = sscanf(id, "%x:%x:%x:%x:%x:%x",
 				&vendor, &device, &subvendor, &subdevice,
 				&class, &class_mask);


