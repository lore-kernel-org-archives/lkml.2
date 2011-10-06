Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821Ab1JFL7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 07:59:44 -0400
Received: from vamos2c.informatik.uni-erlangen.de ([131.188.42.15]:42229 "EHLO
	vamos2c.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935288Ab1JFL7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 07:59:43 -0400
X-Greylist: delayed 2702 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Oct 2011 07:59:42 EDT
From: Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>
To: linux-kbuild@vger.kernel.org
Cc: Jean Sacren <sakiwit@gmail.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org,
        vamos-dev@lists.informatik.uni-erlangen.de
Subject: [PATCH] kconfig: Fix checking return value of 'fwrite'
Organization: Uni Erlangen, Informatik 4, Lehrstuhl =?utf-8?Q?f=C3=BCr?=
 Betriebs- und verteilte Systeme
X-Url: http://www4.informatik.uni-erlangen.de/~tartler
Date: Thu, 06 Oct 2011 13:14:36 +0200
Message-ID: <87lisype1v.fsf@faui43f.informatik.uni-erlangen.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fwrite indicates '1' written member if a zero-length string is written.
---
 scripts/kconfig/lkc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index b633bdb..727d265 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -90,7 +90,7 @@ struct conf_printer {
 /* confdata.c and expr.c */
 static inline void xfwrite(const void *str, size_t len, size_t count, FILE *out)
 {
-	if (fwrite(str, len, count, out) < count)
+	if (len > 0 && fwrite(str, len, count, out) < count)
 		fprintf(stderr, "\nError in writing or end of file.\n");
 }
 
-- 
1.7.0.4

-- 
Reinhard Tartler                     Department of Computer Science IV
Martensstr 1, 91058 Erlangen Germany, University of Erlangen-Nuremberg
            http://www4.informatik.uni-erlangen.de/~tartler
