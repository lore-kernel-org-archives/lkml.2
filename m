Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab0FWJu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 05:50:28 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35064 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab0FWJuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 05:50:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PDB7iLwXBNanvJdqJrtKrEj4mTDa3XPhlBh3g982CIte2RC28/aZm5ITGVI72GPrFa
         ATmQAzrBwHG+KKEx8cVDjVhGouC+OGEX9x6pJj1R+RYF5dbxPdnmqBd9Su8WrLXwGpOZ
         NMX3Dj/OqDtOE5pifrZBDftjNhUisBPk7h5Kw=
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Raffaele Recalcati <raffaele.recalcati@bticino.it>,
       Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Walker <dwalker@fifo99.com>, Joe Perches <joe@perches.com>
Subject: [PATCH] scripts: checkpatch.pl
Date: Wed, 23 Jun 2010 11:49:21 +0200
Message-Id: <1277286561-3448-2-git-send-email-lamiaposta71@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1277286561-3448-1-git-send-email-lamiaposta71@gmail.com>
References: <1277286561-3448-1-git-send-email-lamiaposta71@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raffaele Recalcati <raffaele.recalcati@bticino.it>

I've got a false positive when spaces are present
at the beginning of a line.
So I add this check, obviously outside comments.
This patch is compatible with the actual mainline,
I mean 7e27d6e778cd87b6f2415515d7127eba53fe5d02 commit.

Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
---
 scripts/checkpatch.pl |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a4d7434..315a827 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1433,6 +1433,13 @@ sub process {
 			WARN("please, no space before tabs\n" . $herevet);
 		}
 
+# check for spaces at the beginning of a line.
+		if ($rawline =~ /^\+ / && $rawline !~ /\+ +\*/)  {
+			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
+			WARN("please, no space for starting a line, \
+				excluding comments\n" . $herevet);
+		}
+
 # check we are in a valid C source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c)$/);
 
-- 
1.7.0.4

