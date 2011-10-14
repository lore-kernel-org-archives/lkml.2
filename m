Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab1JNMhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:37:51 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58128 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab1JNMhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:37:50 -0400
X-Nat-Received: from [202.181.97.72]:63597 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1318595866.25827
To: linux-kernel@vger.kernel.org
Cc: gitster@pobox.com
Subject: [Git] partial downloading feature
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201110142137.JEJ69242.FLSVFQJtFMOOOH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 14 Oct 2011 21:37:43 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 14102011 #5484850, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Is there any chance to add support for "[path...]" argument of git-archive
command to gitweb.cgi interface (something like below untested patch) ?

I sometimes download kernel source from snapshot links on
http://git.kernel.org/?p=linux/kernel/git/next/linux-next-history.git;a=summary
but I don't need 100MB tarball when wanting to download a single subdirectory.

diff --git a/gitweb/gitweb.perl b/gitweb/gitweb.perl
index 85d64b2..aedf11e 100755
--- a/gitweb/gitweb.perl
+++ b/gitweb/gitweb.perl
@@ -754,6 +754,7 @@ our @cgi_param_mapping = (
 	searchtext => "s",
 	searchtype => "st",
 	snapshot_format => "sf",
+	snapshot_subdir => "ss",
 	extra_options => "opt",
 	search_use_regexp => "sr",
 	ctag => "by_tag",
@@ -6681,7 +6682,7 @@ sub git_snapshot {
 	my $cmd = quote_command(
 		git_cmd(), 'archive',
 		"--format=$known_snapshot_formats{$format}{'format'}",
-		"--prefix=$prefix/", $hash);
+		"--prefix=$prefix/", $hash, $snapshot_subdir);
 	if (exists $known_snapshot_formats{$format}{'compressor'}) {
 		$cmd .= ' | ' . quote_command(@{$known_snapshot_formats{$format}{'compressor'}});
 	}
