Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab2BBV2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:28:51 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38839 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab2BBV2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:28:50 -0500
X-Originating-IP: 217.70.178.135
X-Originating-IP: 50.43.15.19
Date: Thu, 2 Feb 2012 13:28:41 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across lines
Message-ID: <20120202212840.GB11308@leaf>
References: <20120202200621.GB9279@leaf>
 <1328214989.18641.54.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328214989.18641.54.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 12:36:29PM -0800, Joe Perches wrote:
> On Thu, 2012-02-02 at 12:06 -0800, Josh Triplett wrote:
> > Documentation/CodingStyle recommends not splitting quoted strings across
> > lines, because it breaks the ability to grep for the string.  checkpatch
> > already makes an exception to the 80-column rule for quoted strings to
> > allow this.  Rather than just allowing it, actively warn about quoted
> > strings split across lines.
> []
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
> > @@ -1737,6 +1737,17 @@ sub process {
> []
> > +# Check for strings broken across lines (breaks greppability).  Make an
> > +# exception when the previous string ends in a newline (multiple lines in one
> > +# string constant) or \n\t (common in inline assembly to indent the instruction
> > +# on the following line).
> > +		if ($line =~ /^\+\s*"/ &&
> > +		    $prevline =~ /"\s*$/ &&
> > +		    $prevrawline !~ /\\n(?:\\t)*"\s*$/) {
> > +			WARN("SPLIT_STRING",
> > +			     "quoted string split across lines\n" . $herecurr);
> 
> Seems sensible but there are also asm uses like:
> 
> arch/x86/include/asm/pvclock.h:         "xor  %5,%5    ; "
>                 "add  %4,%%eax ; "

I did see those, yes.  However, a quick grep through the kernel shows
that those occur quite rarely compared to \n or \n\t; the latter looks
like the standard style.  How about I provide a patch for
Documentation/CodingStyle adding a chapter on inline assembly, with that
and other style guidelines? :)

- Josh Triplett
