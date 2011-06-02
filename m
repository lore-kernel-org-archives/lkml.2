Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab1FBTO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 15:14:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39879 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab1FBTOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 15:14:55 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=uRt87i7PWLwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=BzA7jUPdUmwhktj2RSoA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110602191453.430527289@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 02 Jun 2011 15:13:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] ktest: Fix off-by-one in config bisect result
References: <20110602191334.417940259@goodmis.org>
Content-Disposition: inline; filename=0001-ktest-Fix-off-by-one-in-config-bisect-result.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Because in perl the array size returned by $#arr, is the last
index and not the actually size of the array, we end the config
bisect early, thinking there is only one config left when there
are in fact two. Thus the result has a 50% chance of picking
the correct config that caused the problem.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 1fd29b2..8dc8c3c 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1638,7 +1638,7 @@ sub run_config_bisect {
 	if (!$found) {
 	    # try the other half
 	    doprint "Top half produced no set configs, trying bottom half\n";
-	    @tophalf = @start_list[$half .. $#start_list];
+	    @tophalf = @start_list[$half + 1 .. $#start_list];
 	    create_config @tophalf;
 	    read_current_config \%current_config;
 	    foreach my $config (@tophalf) {
@@ -1690,7 +1690,7 @@ sub run_config_bisect {
 	# remove half the configs we are looking at and see if
 	# they are good.
 	$half = int($#start_list / 2);
-    } while ($half > 0);
+    } while ($#start_list > 0);
 
     # we found a single config, try it again unless we are running manually
 
-- 
1.7.4.4


