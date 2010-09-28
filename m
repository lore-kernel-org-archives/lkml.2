Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220Ab0I1JTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 05:19:44 -0400
Received: from suva.vyatta.com ([76.74.103.44]:45889 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab0I1JTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 05:19:25 -0400
X-Greylist: delayed 1947 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Sep 2010 05:19:25 EDT
Message-Id: <20100928084528.884369764@vyatta.com>
User-Agent: quilt/0.48-1
Date: Tue, 28 Sep 2010 17:44:02 +0900
From: Stephen Hemminger <shemminger@vyatta.com>
To: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] namespace.pl: fix source tree name mangling
References: <20100928084400.997539242@vyatta.com>
Content-Disposition: inline; filename=namespace-find-source.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current namespace.pl script does not find source files correctly.
The problem is that the current directory is not the base of the kernel
tree at the point where it calls objdump.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/scripts/namespace.pl	2010-09-27 17:53:29.919433444 +0900
+++ b/scripts/namespace.pl	2010-09-28 09:24:36.891552993 +0900
@@ -167,8 +167,10 @@ sub do_nm
 		printf STDERR "$fullname is not an object file\n";
 		return;
 	}
-	($source = $fullname) =~ s/\.o$//;
-	if (-e "$objtree$source.c" || -e "$objtree$source.S") {
+	$fullname =~ s/\.o$//;
+	$source = $basename;
+	$source =~ s/\.o$//;
+	if (-e "$objtree$fullname.c" || -e "$objtree$fullname.S") {
 		$source = "$objtree$source";
 	} else {
 		$source = "$srctree$source";


