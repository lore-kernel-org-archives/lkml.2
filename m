Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1K1PnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:43:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54188 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab1K1Pm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:42:58 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 06/11] checkpatch: fix EXPORT_SYMBOL handling following a function
Date: Mon, 28 Nov 2011 15:42:48 +0000
Message-Id: <1322494973-29225-7-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322494973-29225-1-git-send-email-apw@canonical.com>
References: <1322494973-29225-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following fragment defeats the DEVICE_ATTR style handing, check for
and ignore the close brace '}' in this context:

    int foo()
    {
    }
    DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
                ata_scsi_lpm_show, ata_scsi_lpm_put);
    EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ca70bbf..1ebfd17 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2127,7 +2127,7 @@ sub process {
 			#   XXX(foo);
 			#   EXPORT_SYMBOL(something_foo);
 			my $name = $1;
-			if ($stat =~ /^.([A-Z_]+)\s*\(\s*($Ident)/ &&
+			if ($stat =~ /^(?:.\s*}\s*\n)?.([A-Z_]+)\s*\(\s*($Ident)/ &&
 			    $name =~ /^${Ident}_$2/) {
 #print "FOO C name<$name>\n";
 				$suppress_export{$realline_next} = 1;
-- 
1.7.5.4

