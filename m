Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab2BBV3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:29:25 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12535 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab2BBV3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:29:24 -0500
Date: Thu, 2 Feb 2012 22:29:45 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Nick Bowler <nbowler@elliptictech.com>
cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across
 lines
In-Reply-To: <20120202202207.GA10041@elliptictech.com>
Message-ID: <alpine.LNX.2.00.1202022225210.16813@swampdragon.chaosbits.net>
References: <20120202200621.GB9279@leaf> <20120202202207.GA10041@elliptictech.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Feb 2012, Nick Bowler wrote:

> On 2012-02-02 12:06 -0800, Josh Triplett wrote:
> > Documentation/CodingStyle recommends not splitting quoted strings across
> > lines, because it breaks the ability to grep for the string.  checkpatch
> > already makes an exception to the 80-column rule for quoted strings to
> > allow this.  Rather than just allowing it, actively warn about quoted
> > strings split across lines.
> [...]
> > +# Check for strings broken across lines (breaks greppability).  Make an

s/greppability/grepability/ ?


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
> 

Agreed. checkpatch needs to not warn about strings like this.
But generally a good idea to warn about "easily grepable strings broken 
into multiple lines" if possible, IMHO...

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

