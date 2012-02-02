Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab2BBUgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:36:37 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:44599 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756108Ab2BBUgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:36:36 -0500
Message-ID: <1328214989.18641.54.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across lines
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 02 Feb 2012 12:36:29 -0800
In-Reply-To: <20120202200621.GB9279@leaf>
References: <20120202200621.GB9279@leaf>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-02 at 12:06 -0800, Josh Triplett wrote:
> Documentation/CodingStyle recommends not splitting quoted strings across
> lines, because it breaks the ability to grep for the string.  checkpatch
> already makes an exception to the 80-column rule for quoted strings to
> allow this.  Rather than just allowing it, actively warn about quoted
> strings split across lines.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -1737,6 +1737,17 @@ sub process {
[]
> +# Check for strings broken across lines (breaks greppability).  Make an
> +# exception when the previous string ends in a newline (multiple lines in one
> +# string constant) or \n\t (common in inline assembly to indent the instruction
> +# on the following line).
> +		if ($line =~ /^\+\s*"/ &&
> +		    $prevline =~ /"\s*$/ &&
> +		    $prevrawline !~ /\\n(?:\\t)*"\s*$/) {
> +			WARN("SPLIT_STRING",
> +			     "quoted string split across lines\n" . $herecurr);

Seems sensible but there are also asm uses like:

arch/x86/include/asm/pvclock.h:         "xor  %5,%5    ; "
                "add  %4,%%eax ; "



