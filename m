Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384Ab0FRSRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 14:17:25 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:46054 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758223Ab0FRSRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 14:17:24 -0400
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jun 2010 14:17:24 EDT
From: "Scott J. Goldman" <scottjg@vmware.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org, "Scott J. Goldman" <scottjg@vmware.com>
Subject: [PATCH] checkpatch: fix false positives involving __percpu attribute
Date: Fri, 18 Jun 2010 11:07:15 -0700
Message-Id: <1276884435-24898-1-git-send-email-scottjg@vmware.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <AANLkTinhcJAphiOo6Gj3pl7NY2oGkAwEw3xJZY_nvOxw@mail.gmail.com>
References: <AANLkTinhcJAphiOo6Gj3pl7NY2oGkAwEw3xJZY_nvOxw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Scott J. Goldman <scottjg@vmware.com>
---
 scripts/checkpatch.pl      |    3 ++-
 tests/t/t7005-attr-matcher |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 87bbb8b..d701956 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -150,7 +150,8 @@ our $Attribute	= qr{
 			____cacheline_aligned|
 			____cacheline_aligned_in_smp|
 			____cacheline_internodealigned_in_smp|
-			__weak
+			__weak|
+			__percpu
 		  }x;
 our $Modifier;
 our $Inline	= qr{inline|__always_inline|noinline};
diff --git a/tests/t/t7005-attr-matcher b/tests/t/t7005-attr-matcher
index a50405f..738da4c 100755
--- a/tests/t/t7005-attr-matcher
+++ b/tests/t/t7005-attr-matcher
@@ -31,6 +31,8 @@ attr	"____cacheline_internodealigned_in_smp"
 
 attr	"__weak"
 
+attr	"__percpu"
+
 attr	"__user"
 attr	"__kernel"
 attr	"__force"
-- 
1.6.0.3

