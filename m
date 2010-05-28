Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438Ab0E1Ory (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:47:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56543 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329Ab0E1Oru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:47:50 -0400
X-Authority-Analysis: v=1.1 cv=EbJB9AiBqsyZPMVATYsj78CfMiBiOs+4P7kRKNQkfg0= c=1 sm=0 a=4dLDkoCVgUEA:10 a=ygRHs6EKU7oA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=qzYJKMEbIQTmfYeDZ3wA:9 a=81zeFieRFidKeBGGXgVebe04j0QA:4 a=_RhRFcbxBZMA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100528144749.537275730@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 May 2010 10:43:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       Toralf Foerster <toralf.foerster@gmx.de>
Subject: [PATCH 3/3] [PATCH 3/3] kconfig: Hide error output in find command in streamline_config.pl
References: <20100528144323.232583082@goodmis.org>
Content-Disposition: inline; filename=0003-kconfig-Hide-error-output-in-find-command-in-streaml.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>

Finding the list of Makefiles in streamline-config should not report errors.

Also move the "chomp" to the @makefiles array instead of doing it in the
for loop. This is more efficient, and does not make it any less readable
by C programmers.

Signed-off-by: Toralf Foerster <toralf.foerster@gmx.de>
LKML-Reference: <201005262022.02928.toralf.foerster@gmx.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 2f8bde8..c70a27d 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -115,7 +115,9 @@ my $ksource = $ARGV[0];
 my $kconfig = $ARGV[1];
 my $lsmod_file = $ARGV[2];
 
-my @makefiles = `find $ksource -name Makefile`;
+my @makefiles = `find $ksource -name Makefile 2>/dev/null`;
+chomp @makefiles;
+
 my %depends;
 my %selects;
 my %prompts;
@@ -215,7 +217,6 @@ if ($kconfig) {
 
 # Read all Makefiles to map the configs to the objects
 foreach my $makefile (@makefiles) {
-    chomp $makefile;
 
     open(MIN,$makefile) || die "Can't open $makefile";
     while (<MIN>) {
-- 
1.7.0


