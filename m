Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab1BKXny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 18:43:54 -0500
Received: from ist.d-labs.de ([213.239.218.44]:54483 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756879Ab1BKXnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 18:43:53 -0500
Date: Sat, 12 Feb 2011 00:43:44 +0100
From: Florian Mickler <florian@mickler.org>
To: Greg KH <greg@kroah.com>
Cc: Harry Wei <jiaweiwei.xiyou@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davem@davemloft.net, rdunlap@xenotime.net,
        trivial@kernel.org
Subject: Re: MAINTAINERS: a question about it
Message-ID: <20110212004344.0c531989@schatten.dmk.lab>
In-Reply-To: <20110211212554.GA11175@kroah.com>
References: <20110211122924.GA2088@gmail.com>
	<20110211154014.GA13716@kroah.com>
	<20110211221433.5f92368c@schatten.dmk.lab>
	<20110211212554.GA11175@kroah.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011 13:25:54 -0800
Greg KH <greg@kroah.com> wrote:

> On Fri, Feb 11, 2011 at 10:14:33PM +0100, Florian Mickler wrote:
> > On Fri, 11 Feb 2011 07:40:14 -0800
> > Greg KH <greg@kroah.com> wrote:
> > 
> > > On Fri, Feb 11, 2011 at 08:29:28PM +0800, Harry Wei wrote:
> > > > Hi us,
> > > >      I saw MAINTAINERS these days. I find we should program a script(shell) for checking if a maintainer added himself in correct position. 
> > > >      Because the MAINTAINERS is in alphabetical order and it has lots of maintainers now.
> > > >      I just want to ask if anyone is doing this work. If it has  been began i will do other things about kernel. If not, i will program this script(shell) for us.
> > > 
> > > Why not just modify the 'scripts/get_maintainers.pl' tool to do this?
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > surely, you mean hooking it into 'scripts/checkpatch.pl' ?
> > 
> 
> No, I hadn't ment that, as I figured get_maintainers.pl already parsed
> the MAINTAINERS file, so it might be easier to do it there.

perl -e '$last = "0"; while (<>) { @F = split(/:/); if ($begin) { if (!/^\s*$/ && length($F[0]) > 1) { unless ($last le $_) { print "header wrongly sorted! ($_)\n"; $err =1; } $last = $_; }}; $begin = 1 if ( $F[0] =~ /\t\t-----------------------------------$/);} exit(1) if ($err); ' < MAINTAINERS

:)

Regards,
Flo
