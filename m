Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab0GKS5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 14:57:19 -0400
Received: from mail.perches.com ([173.55.12.10]:1687 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab0GKS5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 14:57:17 -0400
Subject: [PATCH] scripts/checkpatch.pl: Add strict test of logical test
 continuations at beginning of line
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>, Andy Whitcroft <apw@canonical.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Goyette <paul@whooppee.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
In-Reply-To: <20100711182138.132815e4@hyperion.delvare>
References: <1278859984-22593-1-git-send-email-guenter.roeck@ericsson.com>
	 <1278862266.1501.59.camel@Joe-Laptop.home>
	 <20100711161658.GA23927@ericsson.com>
	 <20100711182138.132815e4@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Jul 2010 11:57:12 -0700
Message-ID: <1278874632.1501.68.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-11 at 18:21 +0200, Jean Delvare wrote:
> On Sun, 11 Jul 2010 09:16:58 -0700, Guenter Roeck wrote:
> > On Sun, Jul 11, 2010 at 11:31:06AM -0400, Joe Perches wrote:
> > > Kernel style seems to prefer having logical tests at
> > > end of line rather than start of line.
> > Ok. Would be nice to have checkpatch.pl complain about it, though,
> > if it is a to-be-enforced rule.
> Please, not again. This has been discussed before, with the conclusion
> that nobody really cares and we don't want to add pointless warnings to
> checkpatch.pl, which in the end will just dissuade people from running
> the script and/or contributing to the kernel at all.

I don't remember that discussion.  Link?

Here's a patch that makes it a "--strict" option
for those who really want to get all the style
checking options.

It also corrects a spelling typo.

Signed-off-by: Joe Perches <joe@perches.com
---
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bd88f11..f0a4c25 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2180,6 +2180,11 @@ sub process {
 			ERROR("space required before the open parenthesis '('\n" . $herecurr);
 		}
 
+# Strict only - logical tests should be at EOL, not beginning of new lines
+		if ($line=~/^.\s*(\&\&|\|\|)/) {
+			CHK("logical test continuations should be on the previous line\n" . $hereprev);
+		}
+
 # Check for illegal assignment in if conditional -- and check for trailing
 # statements after the conditional.
 		if ($line =~ /do\s*(?!{)/) {
@@ -2299,7 +2304,7 @@ sub process {
 
 #no spaces allowed after \ in define
 		if ($line=~/\#\s*define.*\\\s$/) {
-			WARN("Whitepspace after \\ makes next lines useless\n" . $herecurr);
+			WARN("Whitespace after \\ makes next lines useless\n" . $herecurr);
 		}
 
 #warn if <asm/foo.h> is #included and <linux/foo.h> is available (uses RAW line)


