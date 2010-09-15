Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab0IOEet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 00:34:49 -0400
Received: from ist.d-labs.de ([213.239.218.44]:57221 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab0IOEes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 00:34:48 -0400
Date: Wed, 15 Sep 2010 06:34:45 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Christoph Hellwig <hch@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100915063445.7d8ccd4d@schatten.dmk.lab>
In-Reply-To: <1284521324.26719.146.camel@Joe-Laptop>
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
	<20100914194646.52d4bf96@schatten.dmk.lab>
	<1284521324.26719.146.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010 20:28:44 -0700
Joe Perches <joe@perches.com> wrote:

> On Tue, 2010-09-14 at 19:46 +0200, Florian Mickler wrote:
> > On Tue, 14 Sep 2010 10:19:33 -0700
> > ebiederm@xmission.com (Eric W. Biederman) wrote:
> > > Florian Mickler <florian@mickler.org> writes:
> > An interactive mode in git shortlog form of the last year should be
> > possible, i guess. 
> > 
> > I wonder, if git send-email --cc-cmd allows for directing input towards
> > get_maintainer.pl. That would be awesome.
> 
> Yes it does.  You could use any script or direct command
> with arguments you like.
> 
> I sent you privately a script that does that last week.

I think we misunderstand each other. 

For the reference, you talk about this snippet? Or did I overlook smth?

$ cat scripts/send-email-listed-MAINTAINERS-only
#!/bin/bash
if [[ $(basename $1) =~ ^0000- ]] ; then
    ./scripts/get_maintainer.pl --nogit $(dirname $1)/*
else
    ./scripts/get_maintainer.pl --nogit $1
fi


But for the interactive mode I had STDIN in mind. 
And now that I checked, it is indeed possible. I have a quick prove of
concept for an get_maintainer.pl --interactive mode that shows you the
cc's, lists their commits  and let's you choose whom to add to the cc
(using STDERR, as git-send-email.pl obviously expects adresses on
STDOUT).
I haven't experimented much with it, but if it works out expect a
patch. But first I need some coffee and breakfast, as it's morning
over here. :-)

Regards,
Flo


