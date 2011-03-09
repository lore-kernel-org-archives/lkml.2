Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab1CIAbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:31:50 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:57716 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740Ab1CIAbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:31:48 -0500
Date: Tue, 8 Mar 2011 19:31:44 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH 10/15] ftrace: fix event alignment: jbd2:*
Message-ID: <20110309003144.GA26548@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
	mrubin@google.com, Jiaying Zhang <jiayingz@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
 <1291421609-14665-11-git-send-email-dhsharp@google.com>
 <1291427578.16223.12.camel@gandalf.stny.rr.com>
 <1299629005.20306.101.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299629005.20306.101.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 07:03:25PM -0500, Steven Rostedt wrote:
> Now I know why I was so late at adding this. I was waiting for
> Acked-bys ;)
> 
> On Fri, 2010-12-03 at 20:52 -0500, Steven Rostedt wrote:
> > [ Ccing Ted for Acked-by ]
> 
> Ted, Ping?

A month or two ago I did an analysis using the pahole binary (part of
the 'dwarves' package in Debian/Ubuntu) and noticed many more
structures that were flagged as having 'holes' where there were
optimization opportunities.

In addition, (in an interesting example of synchronicity) just this
afternoon, I had talked to Jiaying about a further optimization of the
ext4 trace header files, since she pointed out to me that the 'perf'
binary can actually handle the MAJOR() and MINOR() macros.  So we can
replace 8 bytes of "int major, minor", with a 4 byte dev_t, and save
another 4 bytes (assuming we can move the structure elements around so
we can save a full 8 bytes to avoid structure padding).

Jiaying was also going to send some patches to add some additional
tracepoints to the upstream kernel.

So probably the best thing to do at this point is to drop the ext4 and
jbd2 patches, since Jiaying is about to send me patches that to handle
these optimizations plus some further ones --- and add some additional
tracepoints.  Getting one patch from her that I'll feed in via the
ext4 tree probably will be much simpler than coordinating patches to
the same file from two different trees.

						- Ted
