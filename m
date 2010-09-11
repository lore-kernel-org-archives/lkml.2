Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab0IKJwd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 05:52:33 -0400
Received: from mail.perches.com ([173.55.12.10]:1670 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab0IKJwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 05:52:32 -0400
Subject: Re: [PATCH] scripts/get_maintainer.pl: Add --git-blame --rolestats
 "Authored lines" information
From: Joe Perches <joe@perches.com>
To: Florian Mickler <florian@mickler.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20100911113811.7c685c6d@schatten.dmk.lab>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	 <1284111767.1783.35.camel@Joe-Laptop>
	 <20100910095259.GC23903@sirena.org.uk>
	 <1284113066.1783.69.camel@Joe-Laptop>
	 <20100910101818.GF3068@rakim.wolfsonmicro.main>
	 <1284115665.1783.144.camel@Joe-Laptop>
	 <1284164541.1783.204.camel@Joe-Laptop>
	 <20100911113811.7c685c6d@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Sep 2010 02:52:30 -0700
Message-ID: <1284198750.12180.18.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-11 at 11:38 +0200, Florian Mickler wrote:
> On Fri, 10 Sep 2010 17:22:21 -0700
> Joe Perches <joe@perches.com> wrote:
> > > > Something based on percentage of the driver written rather than log
> > > > entry counts might also be interesting.
> > > There is a --git-blame option, but it uses a count of file commits
> > > active in the file rather than % of lines authored.
> > When options --git-blame and --rolestats are specified, add
> > the maintainers with the qualifying --git-min-percent amount
> > of lines authored of the complete file.  Does not add more
> > authors than specified by --git-max-maintainers.
> > For anyone using hg, this option works but is _very_ slow.
> > It's orders of magnitude slower than git slow.
> > The get_maintainer.pl version was incremented to 0.25.
> > This can be used with or without --git.
> I think this is a good change. I also think this should be made
> default. (linestat is probably more of a hint then nr of commits. 

It's OK but make it default?  No.

It's slower.  A lot slower.
git blame takes a very long time.  It can take minutes.
If you're using hg, it can take a lot more than that.

Run it on something like MAINTAINERS or a largish
active driver and see.

It also doesn't favor recent changes and newer, active
authors.  It also can overemphasis submitters that are
no longer active.


