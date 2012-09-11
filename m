Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab2IKDky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 23:40:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33882 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758041Ab2IKDkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 23:40:12 -0400
Message-ID: <1347334811.2073.2.camel@joe2Laptop>
Subject: Re: [PATCH] Staging: comedi: drivers: fl512: change
 printk(KERN_INFO ... for the prefered pr_info(...
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Bruce Humphrey <brucehum@gmail.com>, abbotti@mev.co.uk,
        fmhess@users.sourceforge.net, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 10 Sep 2012 20:40:11 -0700
In-Reply-To: <20120911025252.GA28112@kroah.com>
References: <1347331815-7278-1-git-send-email-brucehum@gmail.com>
	 <20120911025252.GA28112@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-10 at 19:52 -0700, Greg KH wrote:
> On Tue, Sep 11, 2012 at 04:50:15AM +0200, Bruce Humphrey wrote:
> > Change 5 instances of printk(KERN_INFO, KERN_WARN and KERN_ERROR for the prefered pr_info, pr_warn and pr_error
[]
> > diff --git a/drivers/staging/comedi/drivers/fl512.c b/drivers/staging/comedi/drivers/fl512.c
[]
> > @@ -118,9 +118,9 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
[]
> > -	printk(KERN_INFO "comedi:%d fl512: 0x%04lx", dev->minor, iobase);
> > +	pr_info("comedi:%d fl512: 0x%04lx", dev->minor, iobase);
> 
> Why can't you use dev_info() here, and in other places?  You should use
> the dev_* functions instead of pr_* wherever possible.

Checkpatch instigates these conversions.

Perhaps something like:
---
 scripts/checkpatch.pl |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ca05ba2..e1f4390 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -421,7 +421,7 @@ sub top_of_kernel_tree {
 		}
 	}
 	return 1;
-    }
+}
 
 sub parse_email {
 	my ($formatted_email) = @_;
@@ -2390,8 +2390,10 @@ sub process {
 			my $orig = $1;
 			my $level = lc($orig);
 			$level = "warn" if ($level eq "warning");
+			my $level2 = $level;
+			$level2 = "dbg" if ($level eq "debug");
 			WARN("PREFER_PR_LEVEL",
-			     "Prefer pr_$level(... to printk(KERN_$1, ...\n" . $herecurr);
+			     "Prefer netdev_$level2(netdev, ... then dev_$level2(dev, ... then pr_$level(...  to printk(KERN_$orig ...\n" . $herecurr);
 		}
 
 		if ($line =~ /\bpr_warning\s*\(/) {



