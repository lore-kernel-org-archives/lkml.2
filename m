Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab0INRqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:46:51 -0400
Received: from ist.d-labs.de ([213.239.218.44]:45071 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab0INRqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:46:49 -0400
Date: Tue, 14 Sep 2010 19:46:46 +0200
From: Florian Mickler <florian@mickler.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Joe Perches <joe@perches.com>, Christoph Hellwig <hch@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100914194646.52d4bf96@schatten.dmk.lab>
In-Reply-To: <m1lj749ra2.fsf@fess.ebiederm.org>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1284111767.1783.35.camel@Joe-Laptop>
	<20100911001350.GA11478@infradead.org>
	<1284165074.1783.213.camel@Joe-Laptop>
	<20100911004550.GA30584@infradead.org>
	<20100911112855.6ee6e929@schatten.dmk.lab>
	<m1hbhucdv5.fsf@fess.ebiederm.org>
	<1284364665.22185.116.camel@Joe-Laptop>
	<20100913105434.62b150f7@schatten.dmk.lab>
	<m1lj749ra2.fsf@fess.ebiederm.org>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010 10:19:33 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:
> Florian Mickler <florian@mickler.org> writes:
>



> What is needed is something other than output that is a list of
> email addresses.
> 
> email address foo had x% of non-author signed off bys
> email address foo had y% of author signed off bys
> email address foo had y% of author commits.
> email address foo came from the Maintainers file.

Currently get_maintainer.pl only does signed-off-by counting, it doesn't
take authorship in account, IIRC. That is a good point. It's
information that is easily available. 

> 
> Additionally for email addresses that hit less often a list
> of patch subject titles, and truncated sha1 patch ids.  So
> with luck you can tell at a glance the person is of interest
> and if not you can look at their commits quickly and see.

An interactive mode in git shortlog form of the last year should be
possible, i guess. 

I wonder, if git send-email --cc-cmd allows for directing input towards
get_maintainer.pl. That would be awesome.

> 
> That is all pretty trivial, it should be fast and it should with
> a little care let the bogus results be filtered out quickly.
> 
> > As far as I can see, Andrew is in favor of not caring about
> > false-positives in order to not sacrifice the detection rate of the
> > tool. 
> 
> Which means in time every long time developer will be copied on every
> patch.  That is what we have lkml for.  I don't have a problem with the
> tool returning false positives.  I do have a problem with the tool
> taking away the ability and the responsibility of developers to pay
> attention to which human beings they are sending their patches to.

Fair enough. It does a one year cut-off for the history. But maybe that
is not the best approach. 

> 
> I don't want the tool to do the filtering.  I want the tool to give
> enough information that the person using the tool can get a feel for the
> development history of the affected files and suggestions with a couple
> of metrics how useful someone is when Cc'd on a commit.

I think this is a good approach. 

> 
> > My approach tried to lower the impact of false positives by allowing
> > people to filter between "cc'd as maintainer" and "cc'd as
> > commit_signer".  The former is pretty much never a false positive (as
> > long as MAINTAINERS is up to date) while the latter is more of a
> > hit'n'miss kind of method. 
> 
> And right now get_maintainer.pl is decreasing the relevancy of cc lines
> in commits, which if get_maintainers.pl is used enough could be a
> vicious circle.
> 
> The problem as I see it is you present of a list of email addresses
> without enough information for someone using the tool to guess how
> accurate the results are.

Yes. I guess my patch adresses that somewhat, as it puts more
information in the output by default. But it only uses the information
already present in the script. 

Regards,
Flo

> 
> Eric
> 
