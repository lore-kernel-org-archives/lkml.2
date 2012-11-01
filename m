Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab2KAHMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 03:12:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50708 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753666Ab2KAHMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 03:12:48 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 2/3] checkpatch: Add support for floating point constants
Date: Thu,  1 Nov 2012 00:12:17 -0700
Message-Id: <8e88cd83e9516e529335fc283f31c1b3576a9564.1351736873.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351736873.git.joe@perches.com>
References: <cover.1351736873.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though the kernel doesn't support using floating point constants,
add a regex for them.

Support forms like: 0x123p1, 123e-1, 1.23, 1.5e23f

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 099a0ad..c3a2162 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -227,7 +227,11 @@ our $Inline	= qr{inline|__always_inline|noinline};
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
 
-our $Constant	= qr{(?i:(?:0x[0-9a-f]+|[0-9]+)[ul]*)};
+our $Float_hex	= qr{(?i:0x[0-9a-f]+p-?[0-9]+[fl]?)};
+our $Float_dec	= qr{(?i:((?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+)(?:e-?[0-9]+)?[fl]?))};
+our $Float_int	= qr{(?i:[0-9]+e-?[0-9]+[fl]?)};
+our $Float	= qr{$Float_hex|$Float_dec|$Float_int};
+our $Constant	= qr{(?:$Float|(?i:(?:0x[0-9a-f]+|[0-9]+)[ul]*))};
 our $Assignment	= qr{(?:\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=)};
 our $Compare    = qr{<=|>=|==|!=|<|>};
 our $Operators	= qr{
-- 
1.7.8.112.g3fd21

