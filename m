Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab2BBVQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:16:48 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56635 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab2BBVQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:16:47 -0500
X-Originating-IP: 217.70.178.141
X-Originating-IP: 50.43.15.19
Date: Thu, 2 Feb 2012 13:16:38 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across lines
Message-ID: <20120202211638.GA11308@leaf>
References: <20120202200621.GB9279@leaf>
 <20120202202207.GA10041@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202202207.GA10041@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 03:22:07PM -0500, Nick Bowler wrote:
> On 2012-02-02 12:06 -0800, Josh Triplett wrote:
> > Documentation/CodingStyle recommends not splitting quoted strings across
> > lines, because it breaks the ability to grep for the string.  checkpatch
> > already makes an exception to the 80-column rule for quoted strings to
> > allow this.  Rather than just allowing it, actively warn about quoted
> > strings split across lines.
> [...]
> > +# Check for strings broken across lines (breaks greppability).  Make an
> > +# exception when the previous string ends in a newline (multiple lines in one
> > +# string constant) or \n\t (common in inline assembly to indent the instruction
> > +# on the following line).
> 
> There are tons of strings in the kernel that this makes checkpatch warn
> about where it probably shouldn't.  For example, this one (from
> kernel/auditsc.c:1476):
> 
>   		audit_log_format(ab,
>   			"oflag=0x%x mode=%#ho mq_flags=0x%lx mq_maxmsg=%ld "
>   			"mq_msgsize=%ld mq_curmsgs=%ld",
> 
>   WARNING: quoted string split across lines
>   #1478: FILE: auditsc.c:1478:
>   +			"mq_msgsize=%ld mq_curmsgs=%ld",
> 
> Breaking "greppability" of this string is a non-issue, because this sort
> of string is not really greppable to begin with (and would certainly not
> be any easier to grep for if it were all on one line).

While I agree that in that particular case (heavy on the %formats and
light on the text) you can't easily grep to begin with, the guideline
from CodingStyle still applies, as does the standard guideline about
checkpatch (namely "don't go globally fixing everything it says, but fix
it in new or changed code").

I certainly don't think joining those lines would *hurt*.  Making that
change blindly across the entire kernel doesn't seem worth it, but
changing it on new code seems like a good idea.

In theory checkpatch could try to heuristically ignore cases where the
split in the string occurs immediately before or after a %format, but I
don't fancy writing a regex to match valid printf format specifiers. :)

I still think this patch provides a net win, and I don't think the
example you mentioned represents a false positive.

- Josh Triplett
