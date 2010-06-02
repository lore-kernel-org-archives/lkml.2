Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab0FBU4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:56:42 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:9013 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538Ab0FBU4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:56:40 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPJiBkyrRN+J/2dsb2JhbACeInGnNZoehRYEg0g
X-IronPort-AV: E=Sophos;i="4.53,348,1272844800"; 
   d="scan'208";a="538952318"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Michal Marek <mmarek@suse.cz>
Subject: [PATCH] checkkconfigsymbols.sh: Kconfig symbols sometimes have lowercase letters
X-Message-Flag: Warning: May contain useful information
Date: Wed, 02 Jun 2010 13:56:36 -0700
Message-ID: <adazkzdqhkr.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quite a few Kconfig symbols contain lowercase letters.  The current
checkkconfigsymbols.sh code only contains A-Z in the regexp it uses to
find config symbols in source code, so it comes up with the wrong symbol
to look for in Kconfig files and then generates false positives when it
doesn't find that wrong symbol.  For example checking drivers/net
generates a false positive for MAC89 because the the actual config
option is MAC89x0.

Fix this by also adding a-z to the regexp.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 scripts/checkkconfigsymbols.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkkconfigsymbols.sh b/scripts/checkkconfigsymbols.sh
index 46be3c5..2ca49bb 100755
--- a/scripts/checkkconfigsymbols.sh
+++ b/scripts/checkkconfigsymbols.sh
@@ -14,7 +14,7 @@ find $paths -name '*.[chS]' -o -name 'Makefile' -o -name 'Makefile*[^~]'| while
 do
 	# Output the bare Kconfig variable and the filename; the _MODULE part at
 	# the end is not removed here (would need perl an not-hungry regexp for that).
-	sed -ne 's!^.*\<\(UML_\)\?CONFIG_\([0-9A-Z_]\+\).*!\2 '$i'!p' < $i
+	sed -ne 's!^.*\<\(UML_\)\?CONFIG_\([0-9A-Za-z_]\+\).*!\2 '$i'!p' < $i
 done | \
 # Smart "sort|uniq" implemented in awk and tuned to collect the names of all
 # files which use a given symbol

-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
