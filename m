Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab2EGQUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:20:37 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44231 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756868Ab2EGQUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:20:36 -0400
Message-ID: <1336407634.18931.5.camel@joe2Laptop>
Subject: Re: drivers: Probable misuses of ||
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jarod@redhat.com>
Date: Mon, 07 May 2012 09:20:34 -0700
In-Reply-To: <20120507083602.GA4415@opensource.wolfsonmicro.com>
References: <1333580415.23520.29.camel@joe2Laptop>
	 <1336168477.11505.6.camel@joe2Laptop> <20120504220241.GA6279@sirena.org.uk>
	 <1336169378.11505.10.camel@joe2Laptop>
	 <20120504221333.GU14230@opensource.wolfsonmicro.com>
	 <20120505160042.GA26922@ericsson.com>
	 <20120507083602.GA4415@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 09:36 +0100, Mark Brown wrote:
> On Sat, May 05, 2012 at 09:00:42AM -0700, Guenter Roeck wrote:
> > On Fri, May 04, 2012 at 06:13:33PM -0400, Mark Brown wrote:
> 
> > > Right, but you need to look at the code and explain why this is a
> > > problem.  For example, the case I've left quoted above reads to me like
> > > the intention is "If the chip isn't one I know doesn't like this then
> > > let's do it" which is a perfectly sensible thing to write.
> 
> > I can not really follow your logic here; it is difficult for me to imagine a situation
> > where anything along the line of
> > 	if (val != 1 || val != 2)
> > would provide value other than creating confusion. Maybe you can explain that a bit further.
> 
> Yeah, I hadn't actually read the code closely enough but it's not my
> main point anyway - the main point was that the reports were very easy
> to ignore because they're just a paste in of the error message

Nope, these were the original source codes.

> with no analysis 

You did elide the "Likely the || should be &&" preface.

> they were very likely to just get ignored unless someone has a
> particular interest in the code (which is essentially what I did - I
> glanced at the report but only very briefly).

No worries, I miss things when I scan code too quickly
as well.

> Compare this with the reports from people like Julia Lawall, for example
> - they tend to be very clear.  Even simply adding "...as with || they
> will always be true" would've helped.

I think it's a pretty basic logic error that most all
lkml readers should be able to identify most of the time.

cheers, Joe

