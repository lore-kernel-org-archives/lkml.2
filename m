Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab2CQGNk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 02:13:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40130 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab2CQGNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 02:13:35 -0400
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kay.sievers@vrfy.org, rdunlap@xenotime.net, perex@perex.cz, tiwai@suse.de,
        davem@davemloft.net, Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCHES v2 1/2] Documentation: replace install commands with softdeps
Date: Sat, 17 Mar 2012 03:13:23 -0300
Message-Id: <1331964803-25570-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.7.9.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/Documentation/networking/bonding.txt b/Documentation/networking/bonding.txt
index 080ad26..2d38eee 100644
--- a/Documentation/networking/bonding.txt
+++ b/Documentation/networking/bonding.txt
@@ -1826,8 +1826,7 @@ an equivalent problem can occur.  In this case, the following can be
 added to modprobe.conf (or modprobe.conf.local, as appropriate), as
 follows (all on one line; it has been split here for clarity):
 
-install bonding /sbin/modprobe tg3; /sbin/modprobe e1000;
-	/sbin/modprobe --ignore-install bonding
+softdep bonding pre: tg3 e1000
 
 	This will, when loading the bonding module, rather than
 performing the normal action, instead execute the provided command.
diff --git a/Documentation/sound/oss/AudioExcelDSP16 b/Documentation/sound/oss/AudioExcelDSP16
index e0dc064..30cfccc 100644
--- a/Documentation/sound/oss/AudioExcelDSP16
+++ b/Documentation/sound/oss/AudioExcelDSP16
@@ -54,8 +54,8 @@ Loading MSS and OPL3 needs to pre load the aedsp16 module to set up correctly
 the sound card. Installation dependencies must be written in the modprobe.conf
 file:
 
-install ad1848 /sbin/modprobe aedsp16 && /sbin/modprobe -i ad1848
-install opl3 /sbin/modprobe aedsp16 && /sbin/modprobe -i opl3
+softdep ad1848 pre: aedsp16
+softdep opl3 pre: aedsp16
 
 Then you must load the sound modules stack in this order:
 sound -> aedsp16 -> [ ad1848, opl3 ]
diff --git a/Documentation/sound/oss/README.modules b/Documentation/sound/oss/README.modules
index e691d74..716615a 100644
--- a/Documentation/sound/oss/README.modules
+++ b/Documentation/sound/oss/README.modules
@@ -36,7 +36,7 @@ options adlib_card io=0x388     # FM synthesizer
  Alternatively, if you have compiled in kernel level ISAPnP support:
 
 alias char-major-14 sb
-post-install sb /sbin/modprobe "-k" "adlib_card"
+softdep sb post: adlib_card
 options adlib_card io=0x388
 
   The effect of this is that the sound driver and all necessary bits and
-- 
1.7.9.4

