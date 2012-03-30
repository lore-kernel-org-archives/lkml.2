Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761494Ab2C3Uha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:37:30 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:41178 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761449Ab2C3UhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:37:25 -0400
Message-ID: <4F761980.4050307@xenotime.net>
Date: Fri, 30 Mar 2012 13:37:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH 7/8] Documentation: replace install commands with softdeps
References: <4F761580.3020807@xenotime.net>
In-Reply-To: <4F761580.3020807@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Lucas De Marchi <lucas.demarchi@profusion.mobi>

Documentation: replace install commands with softdeps

Install commands should not be used to specify soft dependencies among
modules. When loading modules it's much better to have a softdep that
modprobe knows what's being done than having to fork/exec another
instance of modprobe to load the other module.

By using a softdep user has also an option to remove the dependencies
when removing the module (and if its refcount dropped to 0)

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---

v2: addressed comments from Takashi Iwai and split the patch in two. There were
some changes to install commands that are better placed in a separate patch


 Documentation/networking/bonding.txt    |    3 +--
 Documentation/sound/oss/AudioExcelDSP16 |    4 ++--
 Documentation/sound/oss/README.modules  |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

--- lnx-33.orig/Documentation/networking/bonding.txt
+++ lnx-33/Documentation/networking/bonding.txt
@@ -1822,8 +1822,7 @@ modules.conf manual page.
 In this case, the following can be added to config files in
 /etc/modprobe.d/ as:
 
-install bonding /sbin/modprobe tg3; /sbin/modprobe e1000;
-	/sbin/modprobe --ignore-install bonding
+softdep bonding pre: tg3 e1000
 
 	This will load tg3 and e1000 modules before loading the bonding one.
 Full documentation on this can be found in the modprobe.d and modprobe
--- lnx-33.orig/Documentation/sound/oss/AudioExcelDSP16
+++ lnx-33/Documentation/sound/oss/AudioExcelDSP16
@@ -54,8 +54,8 @@ Loading MSS and OPL3 needs to pre load t
 the sound card. Installation dependencies must be written in configuration
 files under /etc/modprobe.d/ directory:
 
-install ad1848 /sbin/modprobe aedsp16 && /sbin/modprobe -i ad1848
-install opl3 /sbin/modprobe aedsp16 && /sbin/modprobe -i opl3
+softdep ad1848 pre: aedsp16
+softdep opl3 pre: aedsp16
 
 Then you must load the sound modules stack in this order:
 sound -> aedsp16 -> [ ad1848, opl3 ]
--- lnx-33.orig/Documentation/sound/oss/README.modules
+++ lnx-33/Documentation/sound/oss/README.modules
@@ -36,7 +36,7 @@ options adlib_card io=0x388     # FM syn
  Alternatively, if you have compiled in kernel level ISAPnP support:
 
 alias char-major-14 sb
-post-install sb /sbin/modprobe "-k" "adlib_card"
+softdep sb post: adlib_card
 options adlib_card io=0x388
 
   The effect of this is that the sound driver and all necessary bits and
