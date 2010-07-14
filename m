Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab0GNQQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 12:16:20 -0400
Received: from mail.perches.com ([173.55.12.10]:1873 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753Ab0GNQQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 12:16:19 -0400
Subject: Re: Possible false positive from checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100714131447.GC20746@shadowen.org>
References: <4C3B5660.8020405@lwfinger.net>
	 <1278959315.1501.261.camel@Joe-Laptop.home> <4C3B608B.9010501@lwfinger.net>
	 <1278961381.1501.284.camel@Joe-Laptop.home> <4C3B6F03.8060708@lwfinger.net>
	 <1278964147.1501.291.camel@Joe-Laptop.home>
	 <20100714131447.GC20746@shadowen.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 09:16:17 -0700
Message-ID: <1279124177.11873.46.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 14:14 +0100, Andy Whitcroft wrote:
> On Mon, Jul 12, 2010 at 12:49:07PM -0700, Joe Perches wrote:
> > On Mon, 2010-07-12 at 14:37 -0500, Larry Finger wrote:
> > > That looks good. At least it makes clear what is wrong.
> > > Should it be an error, or just a warning?
> > I don't much care.
> > If Andy wants to do anything, let him decide.
> > Perhaps the new test should be
> > 	if ($rest =~ /\s*,\s*$/)
> I am not sure these are even invalid are they?  Macro abuse of this sort
> is always going to throw up exceptions.  Hrmm.

This seems to work better.

---
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bd88f11..548f8d9 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2393,6 +2393,9 @@ sub process {
 				^\"|\"$
 			}x;
 			#print "REST<$rest> dstat<$dstat>\n";
+			if ($rest =~ /,\s*$/ || $dstat =~ /,\s*$/) {
+			    ERROR("Macros should not end with a trailing comma\n" . "$here\n$ctx\n");
+			}
 			if ($rest ne '') {
 				if ($rest !~ /while\s*\(/ &&
 				    $dstat !~ /$exceptions/)



