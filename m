Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1CWDli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:41:38 -0400
Received: from kroah.org ([198.145.64.141]:37673 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab1CWDlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:41:36 -0400
Date: Tue, 22 Mar 2011 20:42:02 -0700
From: Greg KH <greg@kroah.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, oakad@yahoo.com
Subject: Re: [PATH 0/4] Memstick patches for 2.6.39
Message-ID: <20110323034202.GC11329@kroah.com>
References: <1299212213-4255-1-git-send-email-maximlevitsky@gmail.com>
 <1299947013.17988.0.camel@maxim-laptop>
 <1300219210.13493.0.camel@MAIN>
 <20110315140402.334cc55c.akpm@linux-foundation.org>
 <1300590545.15453.3.camel@maxim-laptop>
 <20110319234701.0eab3744.akpm@linux-foundation.org>
 <1300621371.15768.11.camel@maxim-laptop>
 <20110322162108.a4b70291.akpm@linux-foundation.org>
 <1300841974.3588.4.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300841974.3588.4.camel@maxim-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 02:59:34AM +0200, Maxim Levitsky wrote:
> On Tue, 2011-03-22 at 16:21 -0700, Andrew Morton wrote:
> > On Sun, 20 Mar 2011 13:42:51 +0200
> > Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > 
> > > On Sat, 2011-03-19 at 23:47 -0700, Andrew Morton wrote:
> > > > On Sun, 20 Mar 2011 05:09:05 +0200 Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > > > 
> > > 
> > > ...
> > >
> > > Also, I don't have much time now to improve the ms_block driver till
> > > this summer (studying).
> > > The driver works. Yes it has a flaw in regard to scatterlist processing,
> > > because I didn't find a better way to deal with this monster, but I will
> > > fix that later. I am not the kind of guy that runs away after a merge.
> > > It would be nice to just see my code in kernel, code I wrote more that a
> > > year ago.
> > > 
> > > This flaw is purely theoretical. Driver does work.
> > 
> > Lots of code is "flawed but works".  The place for such code is
> > drivers/staging/ - it gets put in there so the code is available for
> > those who need the driver and the code is later moved over into
> > drivers/ once the flaws have been addressed.
> > 
> > So a path forward here would be for us to put the driver and the
> > sglist extensions into a directory under drivers/staging/.
> Ok, I won't be fighting with you over this one.
> 
> However, I ask for this:
> 
> 
> 1. Please merge r592.c, it doesn't depend on anything.

What type of driver is that?

> 2. Please review ms_block.c for other problems that might prevent merge.
> For example when I published the sg list helpers, nobody told me that I
> am not allowed to add them. Actually the opposite, I was told to put
> them in scatterlist.c.
> When I did so, again I was told that I didn't do the kerneldoc comments
> right, and also was told to improve few of the functions.
> Now I did all that, and I am told that scatterlist usage in my driver is
> no-go. OK. But what else is there that you don't like?

Ick, that's not nice, but formatting issues are usually the easiest to
pick on, sorry for that happening.

So the result is to use the block layer functions instead, right?  How
much work do you imagine that would take to do?

If it's a bunch, care to put the code in drivers/staging/ now?  I'll
gladly take the patches to queue them up for .40.

thanks,

greg k-h
