Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab0JRR60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 13:58:26 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:45623 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab0JRR6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 13:58:25 -0400
Date: Mon, 18 Oct 2010 19:58:23 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Joe Perches <joe@perches.com>
Cc: walter harms <wharms@bfs.de>, devel@driverdev.osuosl.org, gregkh@suse.de,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers/staging/cx25821: Use kstrdup
In-Reply-To: <1287424542.20968.121.camel@Joe-Laptop>
Message-ID: <Pine.LNX.4.64.1010181957520.15744@ask.diku.dk>
References: <1287341311-11161-1-git-send-email-julia@diku.dk> 
 <1287341311-11161-2-git-send-email-julia@diku.dk> <4CBBF407.7060705@bfs.de>
  <Pine.LNX.4.64.1010181019370.22530@ask.diku.dk> <4CBC12EC.60109@bfs.de> 
 <Pine.LNX.4.64.1010181421240.25099@ask.diku.dk>  <1287423539.20968.115.camel@Joe-Laptop>
  <Pine.LNX.4.64.1010181942570.15744@ask.diku.dk> <1287424542.20968.121.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Joe Perches wrote:

> On Mon, 2010-10-18 at 19:44 +0200, Julia Lawall wrote:
> > On Mon, 18 Oct 2010, Joe Perches wrote:
> > 
> > > Perhaps it's more readable code to recheck the
> > > field name flag and introduce a temporary
> > > char *fname so the slightly unusual reuse of
> > > 	field = kstrdup(field, GFP)
> > > becomes
> > > 	field = kstrdup(fname, GFP)
> > 
> > Before I had a local variable filename.  I preferred that because I felt 
> > uneasy about putting both statically and dynamically allocated memory in 
> > the same field.  But it does mean adding a new local variable.
> 
> I think readability is better using a temporary.
> 
> > I'm not sure to understand "recheck the field name flag", though.
> 
> Sorry, poor wording.  I meant using this style:
> 
> 	if (field && *field)
> 		foo
> 	else if (field)
> 		bar
> 	else
> 		baz
> 
> instead of:
> 
> 	if (field) {
> 		if (*field)
> 			foo
> 		else
> 			bar
> 	} else
> 		baz

OK :)  I'll do that.

julia
