Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab1CIAwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:52:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57077 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab1CIAwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:52:07 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=Of1ChBLq4JMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3N689xgryJoZ9Sbjy_sA:9 a=TSeeINvD4GJX0hq2ycgA:7 a=xl6qlgLYruEcaaX3qkGDD4Apw-IA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 10/15] ftrace: fix event alignment: jbd2:*
From: Steven Rostedt <rostedt@goodmis.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com, Jiaying Zhang <jiayingz@google.com>
In-Reply-To: <20110309003144.GA26548@thunk.org>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	 <1291421609-14665-11-git-send-email-dhsharp@google.com>
	 <1291427578.16223.12.camel@gandalf.stny.rr.com>
	 <1299629005.20306.101.camel@gandalf.stny.rr.com>
	 <20110309003144.GA26548@thunk.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 08 Mar 2011 19:41:45 -0500
Message-ID: <1299631305.20306.113.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 19:31 -0500, Ted Ts'o wrote:
> On Tue, Mar 08, 2011 at 07:03:25PM -0500, Steven Rostedt wrote:
> > Now I know why I was so late at adding this. I was waiting for
> > Acked-bys ;)
> > 
> > On Fri, 2010-12-03 at 20:52 -0500, Steven Rostedt wrote:
> > > [ Ccing Ted for Acked-by ]
> > 
> > Ted, Ping?
> 
> A month or two ago I did an analysis using the pahole binary (part of
> the 'dwarves' package in Debian/Ubuntu) and noticed many more
> structures that were flagged as having 'holes' where there were
> optimization opportunities.
> 
> In addition, (in an interesting example of synchronicity) just this
> afternoon, I had talked to Jiaying about a further optimization of the
> ext4 trace header files, since she pointed out to me that the 'perf'
> binary can actually handle the MAJOR() and MINOR() macros.  So we can
> replace 8 bytes of "int major, minor", with a 4 byte dev_t, and save
> another 4 bytes (assuming we can move the structure elements around so
> we can save a full 8 bytes to avoid structure padding).
> 
> Jiaying was also going to send some patches to add some additional
> tracepoints to the upstream kernel.
> 
> So probably the best thing to do at this point is to drop the ext4 and
> jbd2 patches, since Jiaying is about to send me patches that to handle
> these optimizations plus some further ones --- and add some additional
> tracepoints.  Getting one patch from her that I'll feed in via the
> ext4 tree probably will be much simpler than coordinating patches to
> the same file from two different trees.

OK, thanks for the explanation. I'll go ahead and drop those two patches
from my queue.

-- Steve


