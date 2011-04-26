Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1DZXIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 19:08:40 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:38926 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752503Ab1DZXIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 19:08:39 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB7504C.6060507@verizon.net>
Date: Tue, 26 Apr 2011 19:07:56 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH V2] kbuild: don't warn about include/linux/version.h not including
 itself
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes checkversion.pl not warn that include/linux/version.h
dosen't include itself.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/checkversion.pl |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/scripts/checkversion.pl b/scripts/checkversion.pl
index b444e89..cf4b1dc 100755
--- a/scripts/checkversion.pl
+++ b/scripts/checkversion.pl
@@ -12,6 +12,8 @@ $| = 1;
 my $debugging;
 
 foreach my $file (@ARGV) {
+    if($file !~ "include/linux/version\.h")
+    {
     # Open this file.
     open( my $f, '<', $file )
       or die "Can't open $file: $!\n";
@@ -67,4 +69,5 @@ foreach my $file (@ARGV) {
     }
 
     close($f);
+    }
 }
-- 
1.7.5.rc1

