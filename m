Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab0KYT0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 14:26:00 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42382 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab0KYTZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 14:25:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=DelmF+VUlpk8153x8Vyeo8TNDSVVedSokwU+8P4SPNdRzzCEWy/OvFE5BgtWPTJX32
         faL3vPHrDtEX9Cg7/oDABqXrYRGuo3uTHkLQ9xbUJ2vErZ5U6KWbCNmSCfu89930l3Z/
         +AmHGNTNdHrci89noVnfYvQzIjFoeCJAbkGVE=
Date: Thu, 25 Nov 2010 22:25:45 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andy Whitcroft <apw@canonical.com>, joe@perches.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch] checkpatch.pl: discourage pointless changes
Message-ID: <20101125192545.GV1522@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andy Whitcroft <apw@canonical.com>, joe@perches.com,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a message when people use the --file option to checkpatch.pl:

NOTE: Checkpatch is a only a tool.
      Only send patches which make the code unambiguously more readable.
      Don't waste maintainer time.

Most people use checkpatch.pl to check patches which they have written,
but newbies use it with the --file option to find things to change.
>From the newbie perspective, we wrote checkpatch.pl so we should 
obviously be happy to fix all the errors it reports.  But actually 
maitainers get cranky and that makes the newbies sad and everyone has
a bad day.

The message is quite blunt, but probably if people's feelings are hurt
by a print from a script that means they are taking the script too
seriously.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3c7fc0..36f95c1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2937,6 +2937,13 @@ sub process {
 		}
 	}
 
+	if ($file && $clean == 0 && $quiet == 0) {
+		print "NOTE: Checkpatch is a only a tool.\n";
+		print "      Only send patches which make the code unambiguously more readable.\n";
+		print "      Don't waste maintainer time.\n";
+		print "\n";
+	}
+
 	if ($clean == 1 && $quiet == 0) {
 		print "$vname has no obvious style problems and is ready for submission.\n"
 	}
