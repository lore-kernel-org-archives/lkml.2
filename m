Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964782Ab1C3VGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:06:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:65216 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933228Ab1C3VGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132912"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: tj@kernel.org, jbarnes@virtuousgeek.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [55/275] PCI: pci-stub: ignore zero-length id parameters
Message-Id: <20110330210451.94FFE3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/pci/pci-stub.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.35.y/drivers/pci/pci-stub.c
===================================================================
--- linux-2.6.35.y.orig/drivers/pci/pci-stub.c	2011-03-29 22:51:47.688502940 -0700
+++ linux-2.6.35.y/drivers/pci/pci-stub.c	2011-03-29 23:02:59.304317971 -0700
@@ -54,6 +54,9 @@
 			subdevice = PCI_ANY_ID, class=0, class_mask=0;
 		int fields;
 
+		if (!strlen(id))
+			continue;
+
 		fields = sscanf(id, "%x:%x:%x:%x:%x:%x",
 				&vendor, &device, &subvendor, &subdevice,
 				&class, &class_mask);
