Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab1KKH7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 02:59:30 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:57574 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1KKH73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 02:59:29 -0500
X-IronPort-AV: E=Sophos;i="4.69,493,1315180800"; 
   d="scan'208";a="8878716"
Subject: [PATCH] get_maintainers.pl: Follow renames when looking up commit
 signers
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Fri, 11 Nov 2011 07:59:26 +0000
Message-ID: <1320998367.16747.127.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I happen to have had a commit to various network drivers since the big
renaming/reorg which happened to drivers/net recently. This means that I
now appear to be in the top few commit signers (by %age) for many of
them so am getting sent all sorts of stuff and people who are involved
with the driver are not. e.g. (to pick one at random):

        $ ./scripts/get_maintainer.pl -f drivers/net/ethernet/nvidia/forcedeth.c
        "David S. Miller" <davem@davemloft.net> (commit_signer:5/7=71%)
        Ian Campbell <ian.campbell@citrix.com> (commit_signer:2/7=29%)
        Eric Dumazet <eric.dumazet@gmail.com> (commit_signer:1/7=14%)
        Jeff Kirsher <jeffrey.t.kirsher@intel.com> (commit_signer:1/7=14%)
        Jiri Pirko <jpirko@redhat.com> (commit_signer:1/7=14%)
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
        linux-kernel@vger.kernel.org (open list)

With the following patch the renames are followed and the result appears
much more sensible:

        $ ./scripts/get_maintainer.pl -f drivers/net/ethernet/nvidia/forcedeth.c
        "David S. Miller" <davem@davemloft.net> (commit_signer:31/34=91%)
        Joe Perches <joe@perches.com> (commit_signer:11/34=32%)
        Szymon Janc <szymon@janc.net.pl> (commit_signer:5/34=15%)
        Jiri Pirko <jpirko@redhat.com> (commit_signer:3/34=9%)
        Paul <paul.gortmaker@windriver.com> (commit_signer:2/34=6%)
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
        linux-kernel@vger.kernel.org (open list)
        
Signed-off-by: Ian.Campbell@citrix.com

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 4594f33..f32a04c 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -95,7 +95,7 @@ my %VCS_cmds_git = (
     "execute_cmd" => \&git_execute_cmd,
     "available" => '(which("git") ne "") && (-d ".git")',
     "find_signers_cmd" =>
-	"git log --no-color --since=\$email_git_since " .
+	"git log --no-color --follow --since=\$email_git_since " .
 	    '--format="GitCommit: %H%n' .
 		      'GitAuthor: %an <%ae>%n' .
 		      'GitDate: %aD%n' .


