Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab0EHW0w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 18:26:52 -0400
Received: from mail.perches.com ([173.55.12.10]:2058 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab0EHW0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 18:26:51 -0400
Subject: [PATCH] scripts/get_maintainer.pl: add .get_maintainer.conf
 default options file
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Mickler <florian@mickler.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
In-Reply-To: <1273354364-6016-1-git-send-email-florian@mickler.org>
References: <4BE46E7D.1040906@s5r6.in-berlin.de>
	 <1273354364-6016-1-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 May 2010 15:26:49 -0700
Message-ID: <1273357609.704.70.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the use of a .get_maintainer.conf file to control the
default options applied when scripts/get_maintainer.pl is run.

.get_maintainer.conf entries can be any valid argument.

Multiple lines may be used, blank lines ignored, # is a comment

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 6f97a13..0c4c7e0 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -97,6 +97,30 @@ my %VCS_cmds_hg = (
     "blame_commit_pattern" => "^([0-9a-f]+):"
 );
 
+if (-f ${lk_path}.get_maintainer.conf) {
+    my @conf_args;
+    open(my $conffile, '<', "${lk_path}.get_maintainer.conf")
+	or warn "$P: Can't open .get_maintainer.conf: $!\n";
+    while (<$conffile>) {
+	my $line = $_;
+
+	$line =~ s/\s*\n?$//g;
+	$line =~ s/^\s*//g;
+	$line =~ s/\s+/ /g;
+
+	next if ($line =~ m/^\s*#/);
+	next if ($line =~ m/^\s*$/);
+
+	my @words = split(" ", $line);
+	foreach my $word (@words) {
+	    last if ($word =~ m/^#/);
+	    push (@conf_args, $word);
+	}
+    }
+    close($conffile);
+    unshift(@ARGV, @conf_args) if @conf_args;
+}
+
 if (!GetOptions(
 		'email!' => \$email,
 		'git!' => \$email_git,


