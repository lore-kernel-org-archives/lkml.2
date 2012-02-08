Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab2BHJXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 04:23:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab2BHJXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 04:23:33 -0500
Date: Wed, 8 Feb 2012 10:23:31 +0100
From: Jan Kara <jack@suse.cz>
To: Wolfram Gloger <wmglo@dent.med.uni-muenchen.de>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: Soft lockup problem
Message-ID: <20120208092331.GA24625@quack.suse.cz>
References: <20120207215737.10744.qmail@md.dent.med.uni-muenchen.de>
 <20120207225246.GA18832@quack.suse.cz>
 <20120207231615.11358.qmail@md.dent.med.uni-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207231615.11358.qmail@md.dent.med.uni-muenchen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 08-02-12 00:16:15, Wolfram Gloger wrote:
> Thanks for your response.
> 
> > From: Jan Kara <jack@suse.cz>
> 
> >   Hmm, then this isn't really a deadlock (at least in your case) but only a
> > rather unresponsive system.
> 
> Well, like the subject says this is a "soft lockup"..
  We differ in terminology a bit but that's not really important when I
know what you mean :)

> When it happened the first time the system actually recovered
> after some hours.
> But like Gerard said, there is no apparent ground for this
> unresponsiveness, there are tons of memory free and no swapping.
  Yeah, interesting. There are no processes waiting for IO either so I'm
puzzled what causes you problems.
 
> > Looking at the backtraces you provided I don't
> > see anything really suspicious. Only maybe fsnotify_mark process - do you
> > use fsnotify?
> 
> I have configured CONFIG_FSNOTIFY=y indeed but don't think I'm using it
> from userspace..
  Well, apparently something uses it because fsnotify_mark thread is just
in the process of destroying some mark. Maybe you could run with
CONFIG_FSNOTIFY=n just to rule out some problems there...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
