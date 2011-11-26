Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1KZTCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 14:02:10 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51880 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab1KZTCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 14:02:06 -0500
Date: Sat, 26 Nov 2011 22:02:00 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: mmarek@suse.cz, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ctags: remove struct forward declarations
Message-ID: <20111126190200.GA13297@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They're quite pointless and obscure location of real structure definition.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 scripts/tags.sh |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -146,6 +146,8 @@ exuberant()
 	--langdef=dotconfig --language-force=dotconfig          \
 	--regex-dotconfig='/^#?[[:blank:]]*(CONFIG_[[:alnum:]_]+)/\1/'
 
+	# Remove structure forward declarations.
+	LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' tags
 }
 
 emacs()
