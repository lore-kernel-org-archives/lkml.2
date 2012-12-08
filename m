Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab2LHU0a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 15:26:30 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60602 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751375Ab2LHU01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 15:26:27 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] checkpatch: Add support for floating point constants
Date: Sat,  8 Dec 2012 12:26:14 -0800
Message-Id: <3124213860dca831abdf91f599d9bc6beeb76c0c.1354998301.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <0b287cacc469535c55296c22acb18f0df3a0c45d.1354998301.git.joe@perches.com>
References: <0b287cacc469535c55296c22acb18f0df3a0c45d.1354998301.git.joe@perches.com>
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
index bd2616d..acf5045 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -230,7 +230,11 @@ our $Inline	= qr{inline|__always_inline|noinline};
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

