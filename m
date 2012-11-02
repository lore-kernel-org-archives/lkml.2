Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762753Ab2KBLc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 07:32:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35602 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751275Ab2KBLc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 07:32:28 -0400
Message-ID: <1351846257.20238.2.camel@joe-AO722>
Subject: Re: [PATCH] staging: gdm72xx: wm_ioctl.h: fixed a macro coding
 style
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kumar amit mehta <gmate.amit@gmail.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, syahn@gctsemi.com,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
In-Reply-To: <20121102081452.GD32762@mwanda>
References: <1351838579-24511-1-git-send-email-gmate.amit@gmail.com>
	 <20121102065555.GC32762@mwanda> <20121102073630.GA30619@gmail.com>
	 <20121102081452.GD32762@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 02 Nov 2012 01:50:57 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.6.0-0ubuntu3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 11:14 +0300, Dan Carpenter wrote:
> On Fri, Nov 02, 2012 at 12:36:30AM -0700, Kumar amit mehta wrote:
> > On Fri, Nov 02, 2012 at 09:55:55AM +0300, Dan Carpenter wrote:
> > > On Thu, Nov 01, 2012 at 11:42:59PM -0700, Kumar Amit Mehta wrote:
> > > > fix for macro coding style.
> > > > 
> > > 
> > > No.  The parenthesis are not needed.  I assume this is a
> > > checkpatch.pl warning?
> > > 
> > > regards,
> > > dan carpenter
> > >
> > Running checkpatch.pl on this file (wm_ioctl.h) returns error.
> > 
> 
> I think there are patches which fix checkpatch.pl for this but they
> haven't been merged yet?
> 
> $ ./scripts/checkpatch.pl -f drivers/staging/gdm72xx/wm_ioctl.h
> ERROR: Macros with complex values should be enclosed in parenthesis
> #94: FILE: staging/gdm72xx/wm_ioctl.h:94:
> +#define ifr_name       ifr_ifrn.ifrn_name
> 
> total: 1 errors, 0 warnings, 97 lines checked

Maybe:

 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ec58d31..b3c6a00 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2916,7 +2916,7 @@ sub process {
 			if ($dstat ne '' &&
 			    $dstat !~ /^(?:$Ident|-?$Constant),$/ &&			# 10, // foo(),
 			    $dstat !~ /^(?:$Ident|-?$Constant);$/ &&			# foo();
-			    $dstat !~ /^[!~-]?(?:$Ident|$Constant)$/ &&		# 10 // foo() // !foo // ~foo // -foo
+			    $dstat !~ /^[!~-]?(?:$Ident|$Constant|$Lval)$/ &&		# 10 // foo() // !foo // ~foo // -foo // foo.bar[baz]->bop
 			    $dstat !~ /^'X'$/ &&					# character constants
 			    $dstat !~ /$exceptions/ &&
 			    $dstat !~ /^\.$Ident\s*=/ &&				# .foo =


