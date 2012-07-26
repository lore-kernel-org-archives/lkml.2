Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab2GZGx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 02:53:59 -0400
Received: from mail.nonattached.net ([193.160.39.60]:41609 "EHLO
	mail.nonattached.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab2GZGx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 02:53:57 -0400
From: Dan Luedtke <mail@danrl.de>
To: rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Cc: Dan Luedtke <mail@danrl.de>
Subject: [PATCH 3/3] scripts/kernel-doc: added ids to articles for reference
Date: Thu, 26 Jul 2012 08:52:33 +0200
Message-Id: <1343285553-14275-3-git-send-email-mail@danrl.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343285553-14275-1-git-send-email-mail@danrl.de>
References: <50103793.8000600@xenotime.net>
 <1343285553-14275-1-git-send-email-mail@danrl.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An id has been added to block-level elements "article". This allows
jumping to a particular article via url. E.g. doc.html#func:foo
would sroll down to the documentation of function foo.

Signed-off-by: Dan Luedtke <mail@danrl.de>
---
 scripts/kernel-doc |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 1d3c779..97e037a 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -499,7 +499,7 @@ sub output_highlight {
     }
 }
 
-#output sections in html
+# output sections in html
 sub output_section_html(%) {
     my %args = %{$_[0]};
     my $section;
@@ -659,7 +659,7 @@ sub output_blockhead_html(%) {
     print "<hr>\n";
 }
 
-#output sections in html5
+# output sections in html5
 sub output_section_html5(%) {
     my %args = %{$_[0]};
     my $section;
@@ -679,7 +679,11 @@ sub output_enum_html5(%) {
     my %args = %{$_[0]};
     my ($parameter);
     my $count;
-    print "<article class=\"enum\">\n";
+    my $html5id;
+
+    $html5id = $args{'enum'};
+    $html5id =~ s/[^a-zA-Z0-9\-]+/_/g;
+    print "<article class=\"enum\" id=\"enum:". $html5id . "\">";
     print "<h1>enum " . $args{'enum'} . "</h1>\n";
     print "<ol class=\"code\">\n";
     print "<li>";
@@ -719,8 +723,11 @@ sub output_typedef_html5(%) {
     my %args = %{$_[0]};
     my ($parameter);
     my $count;
+    my $html5id;
 
-    print "<article class=\"typedef\">\n";
+    $html5id = $args{'typedef'};
+    $html5id =~ s/[^a-zA-Z0-9\-]+/_/g;
+    print "<article class=\"typedef\" id=\"typedef:" . $html5id . "\">\n";
     print "<h1>typedef " . $args{'typedef'} . "</h1>\n";
 
     print "<ol class=\"code\">\n";
@@ -737,8 +744,11 @@ sub output_typedef_html5(%) {
 sub output_struct_html5(%) {
     my %args = %{$_[0]};
     my ($parameter);
+    my $html5id;
 
-    print "<article class=\"struct\">\n";
+    $html5id = $args{'struct'};
+    $html5id =~ s/[^a-zA-Z0-9\-]+/_/g;
+    print "<article class=\"struct\" id=\"struct:" . $html5id . "\">\n";
     print "<hgroup>\n";
     print "<h1>" . $args{'type'} . " " . $args{'struct'} . "</h1>";
     print "<h2>". $args{'purpose'} . "</h2>\n";
@@ -806,8 +816,11 @@ sub output_function_html5(%) {
     my %args = %{$_[0]};
     my ($parameter, $section);
     my $count;
+    my $html5id;
 
-    print "<article class=\"function\">\n";
+    $html5id = $args{'function'};
+    $html5id =~ s/[^a-zA-Z0-9\-]+/_/g;
+    print "<article class=\"function\" id=\"func:". $html5id . "\">\n";
     print "<hgroup>\n";
     print "<h1>" . $args{'function'} . "</h1>";
     print "<h2>" . $args{'purpose'} . "</h2>\n";
@@ -865,9 +878,12 @@ sub output_blockhead_html5(%) {
     my %args = %{$_[0]};
     my ($parameter, $section);
     my $count;
+    my $html5id;
 
     foreach $section (@{$args{'sectionlist'}}) {
-	print "<article class=\"doc\">\n";
+	$html5id = $section;
+	$html5id =~ s/[^a-zA-Z0-9\-]+/_/g;
+	print "<article class=\"doc\" id=\"doc:". $html5id . "\">\n";
 	print "<h1>$section</h1>\n";
 	print "<p>\n";
 	output_highlight($args{'sections'}{$section});
-- 
1.7.10

