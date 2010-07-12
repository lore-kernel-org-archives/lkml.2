Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab0GLTDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 15:03:06 -0400
Received: from mail.perches.com ([173.55.12.10]:1708 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab0GLTDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 15:03:03 -0400
Subject: Re: Possible false positive from checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C3B608B.9010501@lwfinger.net>
References: <4C3B5660.8020405@lwfinger.net>
	 <1278959315.1501.261.camel@Joe-Laptop.home> <4C3B608B.9010501@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Jul 2010 12:03:01 -0700
Message-ID: <1278961381.1501.284.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-12 at 13:35 -0500, Larry Finger wrote:
> These are ugly macros that will be eliminated, but for the moment they are in 
> the code. As I stated in my original email, removing the comma from the 
> definition and adding it to the code does fix the checkpatch error, but it 
> should not be necessary.

Hi Larry.

Using checkpatch is not necessary.

If you want generally conforming kernel style,
the macro should not end in a trailing comma.

Feel free to ignore the checkpatch message,

I think the warning is reasonable, though it
could be made more specific.

cheers, Joe

Maybe something like:
---
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bd88f11..7e8a3f4 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2394,8 +2394,10 @@ sub process {
 			}x;
 			#print "REST<$rest> dstat<$dstat>\n";
 			if ($rest ne '') {
-				if ($rest !~ /while\s*\(/ &&
-				    $dstat !~ /$exceptions/)
+				if ($rest eq ",") {
+					ERROR("Macros should not end with a trailing comma\n" . "$here\n$ctx\n");
+				} elsif ($rest !~ /while\s*\(/ &&
+					 $dstat !~ /$exceptions/)
 				{
 					ERROR("Macros with multiple statements should be enclosed in a do - while loop\n" . "$here\n$ctx\n");
 				}



