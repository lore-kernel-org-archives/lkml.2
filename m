Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab1FWRb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:31:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:32991 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012Ab1FWRbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:31:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Tejun Heo <tj@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 051/247] PCI: pci-stub: ignore zero-length id parameters
Date: Thu, 23 Jun 2011 13:25:50 -0400
Message-Id: <1308850146-15061-10-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/pci-stub.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci-stub.c b/drivers/pci/pci-stub.c
index f7b68ca..4ae494b 100644
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
-- 
1.7.4.4

