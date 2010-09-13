Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab0IMIyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:54:37 -0400
Received: from ist.d-labs.de ([213.239.218.44]:47885 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab0IMIyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:54:36 -0400
Date: Mon, 13 Sep 2010 10:54:34 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100913105434.62b150f7@schatten.dmk.lab>
In-Reply-To: <1284364665.22185.116.camel@Joe-Laptop>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1284111767.1783.35.camel@Joe-Laptop>
	<20100911001350.GA11478@infradead.org>
	<1284165074.1783.213.camel@Joe-Laptop>
	<20100911004550.GA30584@infradead.org>
	<20100911112855.6ee6e929@schatten.dmk.lab>
	<m1hbhucdv5.fsf@fess.ebiederm.org>
	<1284364665.22185.116.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 00:57:45 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2010-09-13 at 00:16 -0700, Eric W. Biederman wrote:
> > It is trivial for a human to look at a git log and see which changes
> > were just global cleanups and which changes were actual maintenance.
> > Apparently get_maintainers doesn't have that ability.
> 
> Do you have a useful, trivial or non-trivial algorithm
> to suggest or is that soft commenting?  All I'll say is
> AI can be a surprisingly difficult field.

:) indeed. 

> 
> > Have seen some files with something like 5 years of changes without a
> > single commit by a maintainer and the only changes happening to it are
> > global cleanup changes.
> 
> Then likely there's no actual maintainer for that file.

and which means that get_maintainer.pl --git will output either nothing
(if we somehow get its heuristics to filter correctly) or wrong people. 

> 
> > If get_maintainers would look at MAINTAINERS and validate or invalidate
> > that information by looking at git that would be useful.
> 
> Some entries in MAINTAINERS are outdated.
> Validating MAINTAINERS entries is probably best done once.
> 
> I suggest you try that concept out, see what you get, and
> make public the results.

It is easy to make get_maintainer.pl output less people. 
What is not easy is to get it to decrease false-positives while
not decreasing it's detection rate. 

As far as I can see, Andrew is in favor of not caring about
false-positives in order to not sacrifice the detection rate of the
tool. 

My approach tried to lower the impact of false positives by allowing
people to filter between "cc'd as maintainer" and "cc'd as
commit_signer".  The former is pretty much never a false positive (as
long as MAINTAINERS is up to date) while the latter is more of a
hit'n'miss kind of method. 

Don't know. 

Regards,
Flo

