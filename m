Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab2CUE2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 00:28:19 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44497 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2CUE2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 00:28:17 -0400
X-Originating-IP: 217.70.178.132
X-Originating-IP: 50.43.46.74
Date: Tue, 20 Mar 2012 21:28:05 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across lines
Message-ID: <20120321042805.GB1979@leaf>
References: <20120320210644.GA2493@leaf>
 <1332293056.27711.12.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332293056.27711.12.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 06:24:16PM -0700, Joe Perches wrote:
> On Tue, 2012-03-20 at 14:06 -0700, Josh Triplett wrote:
> > checkpatch already makes an exception to the 80-column rule for quoted
> > strings, and Documentation/CodingStyle recommends not splitting quoted
> > strings across lines, because it breaks the ability to grep for the
> > string.  Rather than just permitting this, actively warn about quoted
> > strings split across lines.
> 
> Hi Josh.
> 
> I don't recall seeing your patch before, but I submitted
> a similar one that I believe Andrew has in his tree.

You reviewed my patch at the time and provided feedback, and I'd
produced a revised version based on that feedback.

> https://lkml.org/lkml/2012/3/2/24

The heuristics in the patch I submitted almost completely eliminate
false positives, which makes my patch suitable for use without --strict.
Having a --strict version which flags *all* wrapped strings seems
potentially reasonable as well (though you'll still want the heuristic
that ignores strings ending in \n or \n\t), but I'd still like to get my
version included with the heuristics that make it suitable as a default.

Among other things, the version you submitted to Andrew will flag
multi-instruction __asm__ directives, multi-line strings printed with a
single printk, and arrays of arbitrary data expressed as strings.

- Josh Triplett
