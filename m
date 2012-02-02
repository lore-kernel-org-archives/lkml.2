Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab2BBUWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:22:13 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:12056 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755334Ab2BBUWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:22:11 -0500
Date: Thu, 2 Feb 2012 15:22:07 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across lines
Message-ID: <20120202202207.GA10041@elliptictech.com>
References: <20120202200621.GB9279@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202200621.GB9279@leaf>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-02 12:06 -0800, Josh Triplett wrote:
> Documentation/CodingStyle recommends not splitting quoted strings across
> lines, because it breaks the ability to grep for the string.  checkpatch
> already makes an exception to the 80-column rule for quoted strings to
> allow this.  Rather than just allowing it, actively warn about quoted
> strings split across lines.
[...]
> +# Check for strings broken across lines (breaks greppability).  Make an
> +# exception when the previous string ends in a newline (multiple lines in one
> +# string constant) or \n\t (common in inline assembly to indent the instruction
> +# on the following line).

There are tons of strings in the kernel that this makes checkpatch warn
about where it probably shouldn't.  For example, this one (from
kernel/auditsc.c:1476):

  		audit_log_format(ab,
  			"oflag=0x%x mode=%#ho mq_flags=0x%lx mq_maxmsg=%ld "
  			"mq_msgsize=%ld mq_curmsgs=%ld",

  WARNING: quoted string split across lines
  #1478: FILE: auditsc.c:1478:
  +			"mq_msgsize=%ld mq_curmsgs=%ld",

Breaking "greppability" of this string is a non-issue, because this sort
of string is not really greppable to begin with (and would certainly not
be any easier to grep for if it were all on one line).

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

