Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab0FDKSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 06:18:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51072 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab0FDKSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 06:18:52 -0400
Date: Fri, 4 Jun 2010 12:18:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Changli Gao <xiaosuo@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: optimize mpage_readpage()
Message-ID: <20100604101848.GA6367@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Al Viro <viro@ZenIV.linux.org.uk>, Changli Gao <xiaosuo@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1275095926-18345-1-git-send-email-xiaosuo@gmail.com>
 <20100529121019.GA25092@liondog.tnic>
 <20100604071906.GC31073@ZenIV.linux.org.uk>
 <20100604081322.GA31027@liondog.tnic>
 <20100604083031.GE31073@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100604083031.GE31073@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Fri, Jun 04, 2010 at 09:30:31AM +0100

> On Fri, Jun 04, 2010 at 10:13:22AM +0200, Borislav Petkov wrote:
> > > > > -	bio = do_mpage_readpage(bio, page, 1, &last_block_in_bio,
> > > > > +	bio = do_mpage_readpage(NULL, page, 1, &last_block_in_bio,
> 
> > Right, the uninitialized warning above happens when you remove the NULL
> > assignment, i.e.
> > 
> > struct bio *bio;
> > 
> > ...
> > 
> > bio = do_mpage_readpage(bio, ...)
> 
> WTF?  His patch does *NOT* leave you with bio = do_mpage_readpage(bio, ...),
> it replaces that with bio = do_mpage_readpage(NULL, ...).
> 
> Which variant has produced a warning?
> 
> > But(!), in the mpage_readpage(), bio _absolutely_ has to be NULL because
> > it is checked if being so later in do_mpage_readpage(), so this one is a
> > complete different story.
> > 
> > To cut a long story short, you're correct, gcc is b0rked when warning
> > about passing addresses of variables to functions which only write to
> > them.
> 
> To make it even shorter, you've misapplied the patch.  Correct?

Yes.

-- 
Regards/Gruss,
Boris.
