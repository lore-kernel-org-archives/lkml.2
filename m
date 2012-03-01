Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201Ab2CAMo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:44:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50805 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759167Ab2CAMo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:44:26 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/5] checkpatch: catch [ ... ] usage when not at the beginning of defination
Date: Thu,  1 Mar 2012 12:44:06 +0000
Message-Id: <1330605850-7873-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330605850-7873-1-git-send-email-apw@canonical.com>
References: <1330605850-7873-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle the [ A ... B ] form deeper into a definition, for example:

    static const unsigned char pci_irq_swizzle[2][PCI_MAX_DEVICES] = {
	    {0, 0, 0, 0, 0, 0, 0, 27, 27, [9 ... PCI_MAX_DEVICES - 1] = 0 },
	    {0, 0, 0, 0, 0, 0, 0, 29, 29, [9 ... PCI_MAX_DEVICES - 1] = 0 },
    };

Reported-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a3b9782..d91a86c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2325,7 +2325,7 @@ sub process {
 			my ($where, $prefix) = ($-[1], $1);
 			if ($prefix !~ /$Type\s+$/ &&
 			    ($where != 0 || $prefix !~ /^.\s+$/) &&
-			    $prefix !~ /{\s+$/) {
+			    $prefix !~ /[{,]\s+$/) {
 				ERROR("BRACKET_SPACE",
 				      "space prohibited before open square bracket '['\n" . $herecurr);
 			}
-- 
1.7.9

