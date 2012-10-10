Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab2JJXPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:15:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52801 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758037Ab2JJXBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:01:48 -0400
X-Sasl-enc: DBdKwAGulnVza9/fggypCaa28urMiRnuFduO23wKQrjq 1349910107
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Yuta Ando <yuta.and@gmail.com>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        linux-kbuild@vger.kernel.org
Subject: [ 031/122] localmodconfig: Fix localyesconfig to set to y not m
Date: Thu, 11 Oct 2012 07:53:17 +0900
Message-Id: <20121010225343.735598738@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuta Ando <yuta.and@gmail.com>

commit 4eae518d4b01b0cbf2f0d8edb5a6f3d6245ee8fb upstream.

The kbuild target 'localyesconfig' has been same as 'localmodconfig'
since the commit 50bce3e "kconfig/streamline_config.pl: merge
local{mod,yes}config". The commit expects this script generates
different configure depending on target, but it was not yet implemented.

So I added code that sets to 'yes' when target is 'localyesconfig'.

Link: http://lkml.kernel.org/r/1349101470-12243-1-git-send-email-yuta.and@gmail.com

Signed-off-by: Yuta Ando <yuta.and@gmail.com>
Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@rostedt.homelinux.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/kconfig/streamline_config.pl |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -605,6 +605,8 @@ foreach my $line (@config_file) {
 	if (defined($configs{$1})) {
 	    if ($localyesconfig) {
 	        $setconfigs{$1} = 'y';
+		print "$1=y\n";
+		next;
 	    } else {
 	        $setconfigs{$1} = $2;
 	    }


