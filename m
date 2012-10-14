Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab2JNOnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:43:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46441 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932087Ab2JNOnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:10 -0400
Message-Id: <20121014143545.418200117@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yuta Ando <yuta.and@gmail.com>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>
Subject: [ 086/147] localmodconfig: Fix localyesconfig to set to y not m
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuta Ando <yuta.and@gmail.com>

commit 4eae518d4b01b0cbf2f0d8edb5a6f3d6245ee8fb upstream.

The kbuild target 'localyesconfig' has been same as 'localmodconfig'
since the commit 50bce3e "kconfig/streamline_config.pl: merge
local{mod,yes}config". The commit expects this script generates
different configure depending on target, but it was not yet implemented.

So I added code that sets to 'yes' when target is 'localyesconfig'.

Link: http://lkml.kernel.org/r/1349101470-12243-1-git-send-email-yuta.and@gmail.com

Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Yuta Ando <yuta.and@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@rostedt.homelinux.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 scripts/kconfig/streamline_config.pl |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 39b6314..3368939 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -601,6 +601,8 @@ foreach my $line (@config_file) {
 	if (defined($configs{$1})) {
 	    if ($localyesconfig) {
 	        $setconfigs{$1} = 'y';
+		print "$1=y\n";
+		next;
 	    } else {
 	        $setconfigs{$1} = $2;
 	    }


