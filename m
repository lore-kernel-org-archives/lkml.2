Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab2FMSlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:41:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49383 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752005Ab2FMSlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:41:44 -0400
Message-ID: <1339612902.28729.2.camel@joe2Laptop>
Subject: [PATCH] get_maintainer: Fix --help warning
From: Joe Perches <joe@perches.com>
To: Paul Bolle <pebolle@tiscali.nl>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 13 Jun 2012 11:41:42 -0700
In-Reply-To: <1339610958.30984.158.camel@x61.thuisdomein>
References: <1339610958.30984.158.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using --help emits a concatenation error.
Fix it.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 0948c6b..8b673dd 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -83,6 +83,8 @@ push(@signature_tags, "Signed-off-by:");
 push(@signature_tags, "Reviewed-by:");
 push(@signature_tags, "Acked-by:");
 
+my $signature_pattern = "\(" . join("|", @signature_tags) . "\)";
+
 # rfc822 email address - preloaded methods go here.
 my $rfc822_lwsp = "(?:(?:\\r\\n)?[ \\t])";
 my $rfc822_char = '[\\000-\\377]';
@@ -473,7 +475,6 @@ my @subsystem = ();
 my @status = ();
 my %deduplicate_name_hash = ();
 my %deduplicate_address_hash = ();
-my $signature_pattern;
 
 my @maintainers = get_maintainers();
 


