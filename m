Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2HCS1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 14:27:16 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39604 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2HCS1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 14:27:15 -0400
X-Originating-IP: 217.70.178.133
X-Originating-IP: 173.246.103.110
Date: Fri, 3 Aug 2012 11:27:08 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Alex Kelly <alex.page.kelly@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/get_maintainer.pl: Default to --no-rolestats when
 output not a terminal
Message-ID: <20120803182706.GA4637@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/get_maintainer.pl defaults to showing --rolestats, which
provides annotations explaining why each person or list might want to
know about a patch.  This works well for interactive use, but breaks
when used with git send-email's --to-cmd or --cc-cmd, resulting in
malformed email headers and mails sent to some but not all recipients.

To avoid the need to explicitly pass --no-rolestats for batch use,
enable --rolestats by default only when outputting to a terminal.

Reported-by: Alex Kelly <alex.page.kelly@gmail.com>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 scripts/get_maintainer.pl |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 8b673dd..dcb0748 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -40,7 +40,8 @@ my $email_use_mailmap = 1;
 my $output_multiline = 1;
 my $output_separator = ", ";
 my $output_roles = 0;
-my $output_rolestats = 1;
+my $output_rolestats = 0;
+$output_rolestats = 1 if -t STDOUT;
 my $scm = 0;
 my $web = 0;
 my $subsystem = 0;
@@ -768,7 +769,8 @@ Other options:
 
 Default options:
   [--email --nogit --git-fallback --m --n --l --multiline -pattern-depth=0
-   --remove-duplicates --rolestats]
+   --remove-duplicates]
+  When outputting to a terminal, --rolestats defaults to enabled.
 
 Notes:
   Using "-f directory" may give unexpected results:
@@ -781,9 +783,10 @@ Notes:
       Used with "--git-blame", does not iterate all files in directory
   Using "--git-blame" is slow and may add old committers and authors
       that are no longer active maintainers to the output.
-  Using "--roles" or "--rolestats" with git send-email --cc-cmd or any
-      other automated tools that expect only ["name"] <email address>
-      may not work because of additional output after <email address>.
+  Using "--roles" or "--rolestats" with git send-email --to-cmd or --cc-cmd, or
+      any other automated tools that expect only ["name"] <email address> may
+      not work because of additional output after <email address>.  These
+      options default to disabled when not outputting to a terminal.
   Using "--rolestats" and "--git-blame" shows the #/total=% commits,
       not the percentage of the entire file authored.  # of commits is
       not a good measure of amount of code authored.  1 major commit may
-- 
1.7.10.4

