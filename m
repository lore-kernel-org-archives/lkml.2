Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751018Ab2AURd2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 12:33:28 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:47058 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750803Ab2AURd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 12:33:27 -0500
Message-ID: <4F1B049A.1020409@xenotime.net>
Date: Sat, 21 Jan 2012 10:31:54 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] scripts/kernel-doc: fix fatal error caused by cfg80211.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

include/net/cfg80211.h uses __must_check in functions that
have kernel-doc notation.  This was confusing scripts/kernel-doc,
so have scripts/kernel-doc ignore "__must_check".

Error(include/net/cfg80211.h:2702): cannot understand prototype: 'struct cfg80211_bss * __must_check cfg80211_inform_bss(...)

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Johannes Berg <johannes@sipsolutions.net>
---
 scripts/kernel-doc |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- lnx-33-rc1.orig/scripts/kernel-doc
+++ lnx-33-rc1/scripts/kernel-doc
@@ -5,7 +5,7 @@ use strict;
 ## Copyright (c) 1998 Michael Zucchi, All Rights Reserved        ##
 ## Copyright (C) 2000, 1  Tim Waugh <twaugh@redhat.com>          ##
 ## Copyright (C) 2001  Simon Huggins                             ##
-## Copyright (C) 2005-2010  Randy Dunlap                         ##
+## Copyright (C) 2005-2012  Randy Dunlap                         ##
 ## 								 ##
 ## #define enhancements by Armin Kuster <akuster@mvista.com>	 ##
 ## Copyright (c) 2000 MontaVista Software, Inc.			 ##
@@ -1785,6 +1785,7 @@ sub dump_function($$) {
     $prototype =~ s/__devinit +//;
     $prototype =~ s/__init +//;
     $prototype =~ s/__init_or_module +//;
+    $prototype =~ s/__must_check +//;
     $prototype =~ s/^#\s*define\s+//; #ak added
     $prototype =~ s/__attribute__\s*\(\([a-z,]*\)\)//;
 
