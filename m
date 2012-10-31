Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546Ab2JaKNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:13:34 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33228 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933174Ab2JaKNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:13:32 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] checkpatch: Find hex constants as a single IDENT
Date: Wed, 31 Oct 2012 03:13:11 -0700
Message-Id: <eb886e0280fd1acc69f26a1cb03a0d35c57b570c.1351578285.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351578285.git.joe@perches.com>
References: <cover.1351578285.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hexadecimal values are currently found in 2 parts.
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
index f18750e..099a0ad 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -227,7 +227,7 @@ our $Inline	= qr{inline|__always_inline|noinline};
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
 
-our $Constant	= qr{(?i:(?:[0-9]+|0x[0-9a-f]+)[ul]*)};
+our $Constant	= qr{(?i:(?:0x[0-9a-f]+|[0-9]+)[ul]*)};
 our $Assignment	= qr{(?:\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=)};
 our $Compare    = qr{<=|>=|==|!=|<|>};
 our $Operators	= qr{
-- 
1.7.8.112.g3fd21

