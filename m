Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab1FIVkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:40:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42534 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab1FIVkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:40:22 -0400
From: Andrew Murray <amurray@mpcdata.com>
To: trivial@kernel.org
Cc: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Murray <amurray@mpcdata.com>,
        Andrew Murray <amurray@mpc-data.co.uk>
Subject: [PATCH] Bootgraph.pl bug fix
Date: Thu,  9 Jun 2011 22:40:10 +0100
Message-Id: <1307655610-28446-1-git-send-email-amurray@mpcdata.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the assumption of the bootgraph.pl script that the
timing information reported by PRINTK_TIME will contain at least one
entry with a time of less than 100 seconds.

Not all boards correctly reset the system timer and in many cases the
inital times reported by PRINTK_TIME is high. When this occurs the
bootchart.pl script fails to give any useful output.

This patch sets the $firsttime variable to the largest value expected
by PRINTK_TIME

Signed-off-by: Andrew Murray <amurray@mpc-data.co.uk>
---
 scripts/bootgraph.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/bootgraph.pl b/scripts/bootgraph.pl
index 12caa82..b78fca9 100644
--- a/scripts/bootgraph.pl
+++ b/scripts/bootgraph.pl
@@ -44,7 +44,7 @@ my %end;
 my %type;
 my $done = 0;
 my $maxtime = 0;
-my $firsttime = 100;
+my $firsttime = 99999;
 my $count = 0;
 my %pids;
 my %pidctr;
-- 
1.7.4.1

