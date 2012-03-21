Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab2CUML0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 08:11:26 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36591 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751679Ab2CUMLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 08:11:25 -0400
Message-ID: <1332331883.29403.31.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across lines
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Wed, 21 Mar 2012 05:11:23 -0700
In-Reply-To: <20120321060544.GA2831@leaf>
References: <20120320210644.GA2493@leaf>
	 <1332293056.27711.12.camel@joe2Laptop> <20120321042805.GB1979@leaf>
	 <1332304558.29403.17.camel@joe2Laptop> <20120321060544.GA2831@leaf>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 23:05 -0700, Josh Triplett wrote:
> On Tue, Mar 20, 2012 at 09:35:58PM -0700, Joe Perches wrote:
> > One improvement might be to check for a line continuation \
> > on $prevline and still produce a warning in that case.
> 
> I'd suggest doing that one as a separate check, "unnecessary line
> continuation", which should flag any use of a line continuation other
> than with a preprocessor directive.  I don't think combining that with
> the wrapped-string check makes sense.

What I suggested is for a case in a #define:

#define subsystem_printk(subsystem, level, format, ...)			\
	netdev_printk(level, (subsystem)->dev, "Some partial format "	\
		      "continued on another line" format,		\
		      ##__VA_ARGS__)

where it's necessary to use line continuations but rewrapping like:

#define subsystem_printk(subsystem, level, format, ...)			\
	netdev_printk(level, (subsystem)->dev, 				\
		      "A coalesced format on a single line" format,	\
 		      ##__VA_ARGS__)

might improve it.

Anyway:

Acked-by: Joe Perches <joe@perches.com>


