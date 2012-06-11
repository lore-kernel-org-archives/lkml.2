Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab2FKIT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:19:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61450 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2FKITY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:19:24 -0400
Date: Mon, 11 Jun 2012 10:19:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, Jan Beulich <JBeulich@suse.com>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,nmi: Fix section mismatch warnings on 32-bit
Message-ID: <20120611081919.GB31556@gmail.com>
References: <1338839763-11140-1-git-send-email-dzickus@redhat.com>
 <4FCDDB7D0200007800088390@nat28.tlf.novell.com>
 <20120605144734.GU32472@redhat.com>
 <4FCE44FC0200007800088524@nat28.tlf.novell.com>
 <20120605183539.GA32472@redhat.com>
 <4FCF57B902000078000887EA@nat28.tlf.novell.com>
 <20120606140357.GB32472@redhat.com>
 <1339055005.18639.11.camel@ThinkPad-T420>
 <20120607124800.GH32472@redhat.com>
 <20120608205138.GA29664@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608205138.GA29664@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Thu, Jun 07, 2012 at 08:48:00AM -0400, Don Zickus wrote:
> > On Thu, Jun 07, 2012 at 03:43:25PM +0800, Li Zhong wrote:
> > > On Wed, 2012-06-06 at 10:03 -0400, Don Zickus wrote:
> > > > On Wed, Jun 06, 2012 at 12:14:33PM +0100, Jan Beulich wrote:
> > > > > > I didn't think it would be compiler dependent as I do not know what
> > > > > > compiler the reporter was using.  I used a RHEL-6 4.4.4 compiler (which
> > > > > > you probably don't have :^) ).
> > > > > 
> > > > > Indeed, somehow I failed to see the obvious - it's commit
> > > > > 72b3fb24713755cf9740b403e95aa67ceedf3509 that causes
> > > > > these problems. Instantiating static data like this just doesn't
> > > > > play with any of the pointers passed being into .init.*.
> > > > > 
> > > > > I'd suggest either open coding register_nmi_handler() (with
> > > > > the static data put into __initdata), or further abstracting it
> > > > > by allowing an optional fifth argument (specifying the section
> > > > > annotation if needed).
> > > > 
> > > > Ah.  Thanks for figuring that out!!  I will post a patch opencoding it.
> > > > 
> > > 
> > > Hi Don, 
> > > 
> > > How about the following patch, adding an optional fifth argument as Jan
> > > mentioned? We don't need change other users of register_nmi_handler(). 
> > 
> > Ah, ok.  I forgot about the variable args syntax.  That works too.  I give
> > a quick test.
> 
> Apparently I was too slow.  Ingo committed my other patch.  I 
> can ask him to revert it and use your smaller/cleaner patch 
> instead?  Or is it big deal to keep the other one?

That's what can happen if patches get sent deep in a thread 
without changing the subject line.

Mind sending a delta patch for it? It appears to be cleaner and 
more flexible.

Thanks,

	Ingo
