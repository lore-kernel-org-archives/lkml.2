Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0JVGaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 02:30:11 -0400
Received: from mail.perches.com ([173.55.12.10]:3508 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab0JVGaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 02:30:10 -0400
Subject: [PATCH] scripts/checkpatch.pl: Add check for declaration of
 pci_device_id
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 23:30:09 -0700
Message-ID: <1287729009.28393.4.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2039acd..9929cec 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1806,6 +1806,11 @@ sub process {
 				$herecurr);
 		}
 
+# check for declarations of struct pci_device_id
+		if ($line =~ /\bstruct\s+pci_device_id\s+\w+\s*\[\s*\]\s*\=\s*\{/) {
+			WARN("Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id\n" . $herecurr);
+		}
+
 # check for new typedefs, only function parameters and sparse annotations
 # make sense.
 		if ($line =~ /\btypedef\s/ &&


