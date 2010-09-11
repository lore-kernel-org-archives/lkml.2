Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab0IKJiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 05:38:15 -0400
Received: from ist.d-labs.de ([213.239.218.44]:35060 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab0IKJiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 05:38:13 -0400
Date: Sat, 11 Sep 2010 11:38:11 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/get_maintainer.pl: Add --git-blame --rolestats
 "Authored lines" information
Message-ID: <20100911113811.7c685c6d@schatten.dmk.lab>
In-Reply-To: <1284164541.1783.204.camel@Joe-Laptop>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1284111767.1783.35.camel@Joe-Laptop>
	<20100910095259.GC23903@sirena.org.uk>
	<1284113066.1783.69.camel@Joe-Laptop>
	<20100910101818.GF3068@rakim.wolfsonmicro.main>
	<1284115665.1783.144.camel@Joe-Laptop>
	<1284164541.1783.204.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 17:22:21 -0700
Joe Perches <joe@perches.com> wrote:

> > > Something based on percentage of the driver written rather than log
> > > entry counts might also be interesting.
> > There is a --git-blame option, but it uses a count of file commits
> > active in the file rather than % of lines authored.
> 
> When options --git-blame and --rolestats are specified, add
> the maintainers with the qualifying --git-min-percent amount
> of lines authored of the complete file.  Does not add more
> authors than specified by --git-max-maintainers.
> 
> For anyone using hg, this option works but is _very_ slow.
> It's orders of magnitude slower than git slow.
> 
> The get_maintainer.pl version was incremented to 0.25.
> 
> This can be used with or without --git.
> 
> For instance:
> 
> $ ./scripts/get_maintainer.pl --git-blame --nogit --rolestats -f lib/bitmap.c
> Paul Jackson <pj@sgi.com> (authored lines:406/613=66%,commits:7/20=35%)
> Akinobu Mita <mita@miraclelinux.com> (authored lines:87/613=14%,commits:3/20=15%)
> Reinette Chatre <reinette.chatre@linux.intel.com> (authored lines:42/613=7%)
> Andrew Morton <akpm@linux-foundation.org> (commits:16/20=80%)
> Paul Mundt <lethal@linux-sh.org> (commits:3/20=15%)
> Randy Dunlap <randy.dunlap@oracle.com> (commits:2/20=10%)
> 
> $ ./scripts/get_maintainer.pl --git-blame --git --rolestats -f lib/bitmap.c
> Andrew Morton <akpm@linux-foundation.org> (commit_signer:4/5=80%,commits:16/20=80%)
> Akinobu Mita <akinobu.mita@gmail.com> (commit_signer:2/5=40%,authored lines:87/613=14%,commits:3/20=15%)
> Jack Steiner <steiner@sgi.com> (commit_signer:1/5=20%)
> Ben Hutchings <ben@decadent.org.uk> (commit_signer:1/5=20%)
> Lee Schermerhorn <lee.schermerhorn@hp.com> (commit_signer:1/5=20%)
> Paul Jackson <pj@sgi.com> (authored lines:406/613=66%,commits:7/20=35%)
> Reinette Chatre <reinette.chatre@linux.intel.com> (authored lines:42/613=7%)
> Paul Mundt <lethal@linux-sh.org> (commits:3/20=15%)
> Randy Dunlap <randy.dunlap@oracle.com> (commits:2/20=10%)
> linux-kernel@vger.kernel.org (open list)
> 
> Signed-off-by: Joe Perches <joe@perches.com>

I think this is a good change. I also think this should be made
default. (linestat is probably more of a hint then nr of commits. 

But I don't think it really solves the same problem as the annotations
on the name. We really want to show who just used a script to cc people
and who made an effort to find the right people to send the patch to.

Cheers,
Flo
