Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1BFS02 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 13:26:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45013 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab1BFS00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 13:26:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=uA9zpTfxRA8VIOtu6SicXJF+1afJZpq6WYYqfWC5NDRv6Rklt9qTYNRTzTsepJq9V7
         sUEsWBpN/o/U5P2W1uRiJ+lIBWsuFbnjjAXDddke0k47OROjukTPcSfgla//y7oftTV+
         0kqViCSrAcEKQBZY6stxPAcmfw34jWbuCaV4I=
Date: Sun, 6 Feb 2011 19:26:16 +0100
From: Ulf Magnusson <ulfalizer.lkml@gmail.com>
To: linux-kbuild@vger.kernel.org
Cc: zippel@linux-m68k.org, mmarek@suse.cz, rdunlap@xenotime.net,
        akpm@linux-foundation.org, andrea.gelmini@gelma.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v3] [ANNOUNCE] kconfig: Kconfiglib: a flexible Python
 Kconfig parser
Message-ID: <20110206182612.GA17388@ulf>
Mail-Followup-To: Ulf Magnusson <ulfalizer.lkml@gmail.com>,
	linux-kbuild@vger.kernel.org, zippel@linux-m68k.org, mmarek@suse.cz,
	rdunlap@xenotime.net, akpm@linux-foundation.org,
	andrea.gelmini@gelma.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch builds on https://lkml.org/lkml/2011/2/5/174 . A compound patch
(original patch + all fixes) is available at
http://dl.dropbox.com/u/10406197/kconfiglib.patch (apply with 'git am').

Changelog:
v3:
	- Forgot to update the documentation for get_mainmenu_text() in v2.
	- s/effect/affect/ in example 7.

v2:
	- Now supports alternative output directories (O=).
	- $-references were expanded as environment variables in some
	  contexts ('source', 'mainmenu', and 'defconfig') where they should
	  have been expanded as symbol values - fixed. The reason this broke
	  so little is that all symbols whose value come from an environment
	  variable are currently called the same thing as that variable.
	- Added the internal special symbol UNAME_RELEASE, used by
	  DEFCONFIG_LIST. Previously get_defconfig_filename() failed to find
	  .configs whose DEFCONFIG_LIST entry involved UNAME_RELEASE - now
	  works.
	- get_defconfig_filename() now searches relative to $srctree before
	  looking in the current directory, just like the C implementation.
	- Updated example 1 to work regardless of build directory.
	- Precompiled a few regexes.

Signed-off-by: Ulf Magnusson <ulfalizer.lkml@gmail.com>
---
Convenience links:

Latest documentation (generated with pydoc -w kconfiglib):
http://dl.dropbox.com/u/10406197/kconfiglib.html

Latest example files (ex1.py updated in v2):
http://dl.dropbox.com/u/10406197/kconfiglib-examples.tar.gz

 scripts/kconfig/kconfiglib.py |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/kconfiglib.py b/scripts/kconfig/kconfiglib.py
index fa3d5ee..964e5cb 100644
--- a/scripts/kconfig/kconfiglib.py
+++ b/scripts/kconfig/kconfiglib.py
@@ -323,7 +323,7 @@ while True:
 
                 sym.set_value(lower_bound)
 
-                # We just changed the value of some symbol. As this may effect
+                # We just changed the value of some symbol. As this may affect
                 # other symbols, keep going.
                 done = False
 
@@ -708,9 +708,9 @@ class Config():
         return self.arch
 
     def get_mainmenu_text(self):
-        """Returns the text of the 'mainmenu' statement (with environment
-        variables expanded to the value they had when the Config was created),
-        or None if the configuration has no 'mainmenu' statement."""
+        """Returns the text of the 'mainmenu' statement (with $-references to
+        symbols replaced by symbol values), or None if the configuration has no
+        'mainmenu' statement."""
         return self._expand_sym_refs(self.mainmenu_text)
 
     def get_defconfig_filename(self):
-- 
1.7.0.4

