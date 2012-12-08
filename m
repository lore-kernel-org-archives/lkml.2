Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab2LHU0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 15:26:19 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47022 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758090Ab2LHU0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 15:26:19 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] checkpatch: Find hex constants as a single IDENT
Date: Sat,  8 Dec 2012 12:26:13 -0800
Message-Id: <0b287cacc469535c55296c22acb18f0df3a0c45d.1354998301.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hexadecimal values are current found in 2 parts.
A hex constant like 0x123456abcdef is found as
0 and then x123456abcdef and later coalesced.

Instead, reverse the order of the 2 searches in
$Constant to find 0x first, then 0 so that the
entire hex constant is found all at once.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f27b0b5..bd2616d 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -230,7 +230,7 @@ our $Inline	= qr{inline|__always_inline|noinline};
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
 
-our $Constant	= qr{(?i:(?:[0-9]+|0x[0-9a-f]+)[ul]*)};
+our $Constant	= qr{(?i:(?:0x[0-9a-f]+|[0-9]+)[ul]*)};
 our $Assignment	= qr{(?:\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=)};
 our $Compare    = qr{<=|>=|==|!=|<|>};
 our $Operators	= qr{
-- 
1.7.8.112.g3fd21

