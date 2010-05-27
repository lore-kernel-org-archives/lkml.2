Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974Ab0E0LmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 07:42:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:44525 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933281Ab0E0LmN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 07:42:13 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18lxnI5ziUl5nYoGJ/nueEK1d3XBHZ4C4duezkjmK
	32IUY81RFT2V0O
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: rostedt@goodmis.org
Subject: [PATCH] streamline_config.pl: use references rather than copied data structures
Date: Thu, 27 May 2010 13:42:08 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34; KDE/4.4.3; i686; ; )
Cc: zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005271342.09066.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMHO there's no need for a copy-by-value

Signed-off-by: Toralf Foerster <toralf.foerster@gmx.de>
---
 scripts/kconfig/streamline_config.pl |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl 
b/scripts/kconfig/streamline_config.pl
index afbd54a..574e68f 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -406,14 +406,14 @@ close(CIN);
 loop:
 foreach my $module (keys(%modules)) {
     if (defined($objects{$module})) {
-       my @arr = @{$objects{$module}};
-       foreach my $conf (@arr) {
+       my $arr = $objects{$module};
+       foreach my $conf (@{$arr}) {
            if (defined($setconfigs{$conf})) {
                next loop;
            }
        }
        print STDERR "module $module did not have configs";
-       foreach my $conf (@arr) {
+       foreach my $conf (@{$arr}) {
            print STDERR " " , $conf;
        }
        print STDERR "\n";
-- 
1.6.4.4

-- 
MfG/Sincerely
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

