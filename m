Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab0LFWX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:23:26 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19108 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab0LFWXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:23:24 -0500
Date: Mon, 6 Dec 2010 23:16:32 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Charles Manning <manningc2@actrix.gen.nz>
cc: Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/8] Add yaffs2 file system: guts code
In-Reply-To: <201012071113.51408.manningc2@actrix.gen.nz>
Message-ID: <alpine.LNX.2.00.1012062311500.17486@swampdragon.chaosbits.net>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com> <201012061450.41675.manningc2@actrix.gen.nz> <201012061355.44032.arnd@arndb.de> <201012071113.51408.manningc2@actrix.gen.nz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010, Charles Manning wrote:

> On Tuesday 07 December 2010 01:55:43 Arnd Bergmann wrote:
> > On Monday 06 December 2010, Charles Manning wrote:
> > > On Wednesday 01 December 2010 11:23:53 you wrote:
> > > > On Tuesday 30 November 2010 22:57:29 Charles Manning wrote:
> > > > It would be better to reorder the functions in each file so that
> > > > you don't need forward declarations. This generally makes reading
> > > > the code easier because it is what people expect to see. It
> > > > also makes it clearer where you have possible recursions in the code.
> > >
> > > Hmmm..
> > > I too prefer minimal use of forward declaration.
> > > Some of them are because I copied the layout of existing kernel code
> > > which uses fwd declarations a lot. eg. fs/jffs2/dir.c  and many of the
> > > examples in Rubini & Corbet.
> >
> > There is not much point in changing the legacy code that's already in
> > the kernel, but let's try to keep it clean for new code. We have a lot
> > of bad examples for coding style that we wouldn't merge these days.
> >
> > In this case, it should be an obvious change with no real downsides.
> 
> Arnd thanks for your input, I appreciate it immensely.
> 
> Is this objection to forward declarations just your personal taste or is this 
> a real issue?
> 

I can only speak for myself here (which obviously makes this comment a 
"personal taste thing).  I personally hate all those forward declarations 
and whenever I'm modifying kernel code I try to see if I can move stuff 
around to get rid of some.
We have to live with what's already in the tree, but there's no reason to 
add more gunk. It's easy to just re-order functions to get rid of the 
forward declarations, so why not just do that - makes it so much nicer to 
read (now and in the future - by thousands of people).


> I can't find any references to forward declarations in any of the coding style 
> docs. I would therefore expect it to be an issue of little consequence. 
> Perhaps I did not look in the right places.
> 

I don't think it's written in stone anywhere, it's just one of those 
thiings where one alternative is obviously so much nicer than the other...


> It is perhaps also worth considering that yaffs has been in use for 8 years 
> and is more widely used than many of the file systems already in the kernel  
> and thus, by some measures, does constitute legacy code.
> 

In terms of mainline Linux kernel inclusion it does not.


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

