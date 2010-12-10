Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab0LJRgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:36:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340Ab0LJRgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:36:21 -0500
Date: Fri, 10 Dec 2010 12:35:33 -0500
From: Dave Jones <davej@redhat.com>
To: Dan Carpenter <error27@gmail.com>,
        Marek Belisko <marek.belisko@open-nandra.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/8] staging: ft1000: Convert char device to debugfs.
Message-ID: <20101210173533.GB2505@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dan Carpenter <error27@gmail.com>,
	Marek Belisko <marek.belisko@open-nandra.com>,
	Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
 <1291890413-15255-2-git-send-email-marek.belisko@open-nandra.com>
 <20101209104336.GT10623@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209104336.GT10623@bicker>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 01:43:36PM +0300, Dan Carpenter wrote:
 > > +	file = debugfs_create_file("device", S_IRUGO | S_IWUGO, dir,
 >                                                        ^^^^^^^
 > > +					NULL, &ft1000fops);
 > 
 > Don't make this world writeable.

we should probably make checkpatch catch this.




Exporting world writable sysfs/debugfs files is usually a bad thing.
Warn about it.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3c7fc0..5075005 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2892,6 +2892,11 @@ sub process {
 				ERROR("lockdep_no_validate class is reserved for device->mutex.\n" . $herecurr);
 			}
 		}
+
+		if ($line =~ /debugfs_create_file.*S_IWUGO/ ||
+		    $line =~ /DEVICE_ATTR.*S_IWUGO/ ) {
+			WARN("Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
