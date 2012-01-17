Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab2AQVMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 16:12:18 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:49991 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab2AQVMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 16:12:17 -0500
Date: Tue, 17 Jan 2012 22:12:15 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsprintf: Prevent NULL dereference using %pNF
Message-ID: <20120117211215.GA18268@rere.qmqm.pl>
References: <1326825433.17202.6.camel@joe2Laptop>
 <20120117.134640.1673981737109339596.davem@davemloft.net>
 <1326826273.17202.11.camel@joe2Laptop>
 <20120117193910.GA17092@rere.qmqm.pl>
 <1326829420.17202.21.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1326829420.17202.21.camel@joe2Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 11:43:40AM -0800, Joe Perches wrote:
> On Tue, 2012-01-17 at 20:39 +0100, Micha³ Miros³aw wrote:
> > On Tue, Jan 17, 2012 at 10:51:13AM -0800, Joe Perches wrote:
> > > On Tue, 2012-01-17 at 13:46 -0500, David Miller wrote:
> > > > From: Joe Perches <joe@perches.com>
> > > > Date: Tue, 17 Jan 2012 10:37:13 -0800
> > > > > Passing NULL to %pNF is done in skb_gso_segment
> > > > > which could be dereferenced.
> > > > skb_gso_segment() should be fixed instead.
> > > Maybe.  Dereferencing NULL is bad form.
> > > Micha³ Miros³aw should fix that as it's his patch.
> > Will do. This is in WARN() and easily fixed.
> > 
> > > noinline_for_stack should be added anyway.
> > 
> > Why? There are no local variables there and inlining this function would
> > actually save stack space as no stack frame would be created for the call.
> Isn't an additional copy of "struct printf_spec spec" on the stack
> in function pointer() now?

If the function is inlined then gcc should know that original is not needed
after call and do no copy. Without inlining, gcc should too, optimize it
because it's a tail call.

We could read the generated assembly to be sure, of course.

Best Regards,
Micha³ Miros³aw
