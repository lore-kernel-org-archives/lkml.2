Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934633Ab2JaKNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:13:48 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:32960 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932992Ab2JaKNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:13:45 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] checkpatch: Add support for decimal constants
Date: Wed, 31 Oct 2012 03:13:12 -0700
Message-Id: <144d8398dd7622b14fc8ee02168bfa8b48702482.1351578285.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351578285.git.joe@perches.com>
References: <cover.1351578285.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though the kernel doesn't support using decimal constants,
add a regex for them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 099a0ad..3e727c5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -227,7 +227,8 @@ our $Inline	= qr{inline|__always_inline|noinline};
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
 
-our $Constant	= qr{(?i:(?:0x[0-9a-f]+|[0-9]+)[ul]*)};
+our $Decimal	= qr{(?:(?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+))};
+our $Constant	= qr{(?:$Decimal|(?i:(?:0x[0-9a-f]+|[0-9]+)[ul]*))};
 our $Assignment	= qr{(?:\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=)};
 our $Compare    = qr{<=|>=|==|!=|<|>};
 our $Operators	= qr{
-- 
1.7.8.112.g3fd21

