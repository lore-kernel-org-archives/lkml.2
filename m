Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0FDIag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 04:30:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38694 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab0FDIae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 04:30:34 -0400
Date: Fri, 4 Jun 2010 09:30:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Borislav Petkov <bp@alien8.de>, Changli Gao <xiaosuo@gmail.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: optimize mpage_readpage()
Message-ID: <20100604083031.GE31073@ZenIV.linux.org.uk>
References: <1275095926-18345-1-git-send-email-xiaosuo@gmail.com>
 <20100529121019.GA25092@liondog.tnic>
 <20100604071906.GC31073@ZenIV.linux.org.uk>
 <20100604081322.GA31027@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604081322.GA31027@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 10:13:22AM +0200, Borislav Petkov wrote:
> > > > -	bio = do_mpage_readpage(bio, page, 1, &last_block_in_bio,
> > > > +	bio = do_mpage_readpage(NULL, page, 1, &last_block_in_bio,

> Right, the uninitialized warning above happens when you remove the NULL
> assignment, i.e.
> 
> struct bio *bio;
> 
> ...
> 
> bio = do_mpage_readpage(bio, ...)

WTF?  His patch does *NOT* leave you with bio = do_mpage_readpage(bio, ...),
it replaces that with bio = do_mpage_readpage(NULL, ...).

Which variant has produced a warning?

> But(!), in the mpage_readpage(), bio _absolutely_ has to be NULL because
> it is checked if being so later in do_mpage_readpage(), so this one is a
> complete different story.
> 
> To cut a long story short, you're correct, gcc is b0rked when warning
> about passing addresses of variables to functions which only write to
> them.

To make it even shorter, you've misapplied the patch.  Correct?
