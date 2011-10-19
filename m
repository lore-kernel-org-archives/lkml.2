Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab1JSABM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 20:01:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48954 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752092Ab1JSABL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 20:01:11 -0400
Message-ID: <1318982469.7569.1.camel@Joe-Laptop>
Subject: Re: checkpatch WARNING: patch prefix 'b' exists, appears to be a
 -p0 patch
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>, Wolfram Sang <w.sang@pengutronix.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 18 Oct 2011 17:01:09 -0700
In-Reply-To: <alpine.DEB.2.00.1110181643450.8149@chino.kir.corp.google.com>
References: <4E9D9558.7040705@cam.ac.uk>
	 <alpine.DEB.2.00.1110181643450.8149@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 16:44 -0700, David Rientjes wrote:
> On Tue, 18 Oct 2011, Jonathan Cameron wrote:
> > This started happening when I run checkpatch on pretty much anything.
> > triggered by the b in this snipped for example
> > diff --git a/arch/arm/mach-pxa/stargate2.c b/arch/arm/mach-pxa/stargate2.c
> > index 3f8d0af..62dc2a8 100644
> > --- a/arch/arm/mach-pxa/stargate2.c
> > +++ b/arch/arm/mach-pxa/stargate2.c
> > @@ -54,6 +54,8 @@
> >  #include <linux/mfd/da903x.h>
> > Anyone else seeing this or have a clue what the heck is going on?

It's done this since:

$ git log -1 1e85572697b348b1a126520349a29654f2ae6a12
commit 1e85572697b348b1a126520349a29654f2ae6a12
Author: Wolfram Sang <w.sang@pengutronix.de>
Date:   Tue Jan 6 14:41:24 2009 -0800

    checkpatch: Add warning for p0-patches
    
    Some people work internally with -p0-patches which has the danger that one
    forgets to convert them to -p1 before mainlining.  Bitten myself and seen
    p0-patches in mailing lists occasionally, this patch adds a warning to
    checkpatch.pl in case a patch is -p0.  If you really want, you can fool
    this check to generate false positives, this is why it just spits a
    warning.  Making the check 100% proof is trickier than it looks, so let's
    start with a version which catches the cases of real use.
    
    [apw@canonical.com: update message language, handle null prefix, add tests]
    Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Andy Whitcroft <apw@canonical.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

I've always ignored it.


