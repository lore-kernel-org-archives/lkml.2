Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0IPQwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 12:52:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63387 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab0IPQwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 12:52:43 -0400
X-Authority-Analysis: v=1.1 cv=0gh5jMB3jHrmQHbUKMg9KP0ZqNkm6dXs7xuA8CfKDuU= c=1 sm=0 a=G6fJhtGuX8gA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=jYQDvjXhX8nxgY1Qnq0A:9 a=9Rr4auapdWiU5qJ75tzP_KwBoT0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2] drivers/net/usb/hso.c: prevent reading
 uninitialized memory
From: Steven Rostedt <rostedt@goodmis.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, j.dumon@option.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org, davem@davemloft.net, stable@kernel.org
In-Reply-To: <20100916180710.07821bdd@lxorguk.ukuu.org.uk>
References: <1284587008.6275.95.camel@dan>
	 <20100916155745.GB14318@home.goodmis.org>
	 <20100916180710.07821bdd@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 16 Sep 2010 12:52:40 -0400
Message-ID: <1284655960.23787.34.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 18:07 +0100, Alan Cox wrote:
> ->tiocmget;
> > >  
> > > +	memset(&icount, 0, sizeof(struct serial_icounter_struct));
> > > +
> > 
> > Move the above to after the spinlocks.
> 
> Why - its a local variable ?
> 
> Easier to write
> 
> 	struct serial_icounter_struct icount = { 0 };
> 
> though

True, but if we want to micro-optimize, moving it after the spinlocks
means we do no zero initialization in the tiocmget == 0. Although gcc
may be smart enough to realize that too.

-- Steve


