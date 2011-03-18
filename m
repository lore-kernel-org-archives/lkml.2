Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab1CRDc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:32:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57015 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab1CRDcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:32:52 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=d6KjmF4z1lEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=bDa5MmDnDYp2R_t6ggkA:9 a=Gz_JoXTBVXDBAhyzFLLqiKaJq8AA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
From: Steven Rostedt <rostedt@goodmis.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110317211548.646b04d2@tpl.lwn.net>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
	 <20110317211548.646b04d2@tpl.lwn.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Mar 2011 23:32:50 -0400
Message-ID: <1300419170.16880.956.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 21:15 -0600, Jonathan Corbet wrote:
> On Thu, 17 Mar 2011 22:52:24 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > The use of kzalloc() is preferred over kmalloc/memset(0) pairs.
> > 
> > When a match is made with "memset(p, 0, s);" a search back through the
> > patch hunk is made looking for "p = kmalloc(s,". If that is found, then
> > a warning is given, suggesting to use kzalloc() instead.
> 
> The Coccinelle stuff already has a lot of this kind of test.  See, for
> example, scripts/coccinelle/api/alloc/kzalloc-simple.cocci.  Suppose
> there is some way all this nice analysis infrastructure could be
> integrated instead of duplicated?  Or am I just a crazy dreamer?
> 

Hmm, to me Coccinelle is sorta the big hammer approach to this. It can
be used to analyze the kernel code that exists. checkpatch is made to
stop developers from adding new crap.

That said, I wonder if there is a way to make one use information from
the other. Perhaps we can make checkpatch read the Concinelle rules.
Honestly, I've never used Concinelle and have no idea how to use it.
Looking at their web site there's a PDF on how to use something called
"spatch" but it seems more complex than checkpatch.

But if we can teach checkpatch to read the rule files, then maybe that
would be beneficial.

-- Steve


