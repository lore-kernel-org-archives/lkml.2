Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab1EXM5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:57:41 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54938 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932098Ab1EXM5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:57:38 -0400
X-Sasl-enc: mPguWTrUaZWBihq+KNMLhW2J3lpxNjpbKf+vQMRotNdR 1306241856
Date: Tue, 24 May 2011 05:48:33 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
        Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20110524124833.GB31776@kroah.com>
References: <20110520161816.dda6f1fd.sfr@canb.auug.org.au>
 <BANLkTimjzzqTS1fELmpb0UivqseLsYOfPw@mail.gmail.com>
 <20110524025151.GA26939@kroah.com>
 <20110524135930.bb4c5506.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110524135930.bb4c5506.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 01:59:30PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Mon, 23 May 2011 19:51:51 -0700 Greg KH <greg@kroah.com> wrote:
> >
> > On Mon, May 23, 2011 at 10:06:40PM -0400, Mike Frysinger wrote:
> > > On Fri, May 20, 2011 at 02:18, Stephen Rothwell wrote:
> > > > Caused by commit e66eed651fd1 ("list: remove prefetching from regular list
> > > > iterators").
> > > >
> > > > I added the following patch for today:
> > > 
> > > probably should get added to whatever tree that commit is coming from
> > > so we dont have bisect hell ?
> > > 
> > > more failures:
> > > drivers/usb/host/isp1362-hcd.c: In function 'isp1362_write_ptd':
> > > drivers/usb/host/isp1362-hcd.c:355: error: implicit declaration of
> > > function 'prefetch'
> > > drivers/usb/host/isp1362-hcd.c: In function 'isp1362_read_ptd':
> > > drivers/usb/host/isp1362-hcd.c:377: error: implicit declaration of
> > > function 'prefetchw'
> > > make[3]: *** [drivers/usb/host/isp1362-hcd.o] Error 1
> > > 
> > > drivers/usb/musb/musb_core.c: In function 'musb_write_fifo':
> > > drivers/usb/musb/musb_core.c:219: error: implicit declaration of
> > > function 'prefetch'
> > > make[3]: *** [drivers/usb/musb/musb_core.o] Error 1
> > > 
> > > although it seems like it should be fairly trivial to look at the
> > > funcs in linux/prefetch.h, grep the tree, and find a pretty good list
> > > of the files that are missing the include
> > 
> > How did this not show up in linux-next?  Where did the patch that caused
> > this show up from?
> > 
> > totally confused,
> 
> :-)
> 
> sfr said above:
> > Caused by commit e66eed651fd1 ("list: remove prefetching from regular
> > list iterators").
> 
> The cause was a patch from Linus ...

Ah, ok, that makes more sense, sorry for the noise.

greg k-h
