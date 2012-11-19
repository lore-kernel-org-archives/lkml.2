Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2KSWFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 17:05:36 -0500
Received: from mail.kernel.org ([198.145.19.201]:54181 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab2KSWFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 17:05:35 -0500
Date: Mon, 19 Nov 2012 14:06:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH 407/493] infiniband: remove use of __devexit
Message-ID: <20121119220632.GA1946@kroah.com>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
 <1353349642-3677-407-git-send-email-wfp5p@virginia.edu>
 <20121119200921.GD1556@obsidianresearch.com>
 <20121119201938.GA5614@kroah.com>
 <20121119214922.GA5636@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121119214922.GA5636@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 02:49:22PM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 19, 2012 at 12:19:38PM -0800, Greg KH wrote:
> > On Mon, Nov 19, 2012 at 01:09:21PM -0700, Jason Gunthorpe wrote:
> > > On Mon, Nov 19, 2012 at 01:25:56PM -0500, Bill Pemberton wrote:
> > > > CONFIG_HOTPLUG is going away as an option so __devexit is no
> > > > longer needed.
> > > 
> > > I'm sad to hear this, it is an easy space saver on my non-modular
> > > emebedded systems :(
> > 
> > Really?  I asked for details, and it was reported that this only saved
> > 1-200 bytes or so.  See the lkml archives for the details of this.
> 
> I just checked for you:
> 
> Old 2.6.16 powerpc 32 kernel:
> 
>    text    data     bss     dec     hex filename
> 2399368  222224  156124 2777716  2a6274 build/vmlinux
> 2394634  221804  156124 2772562  2a4e52 build-nhp/vmlinux
> 
> That looks like around 5154 bytes to me
> 
> New 3.6 powerpc 32 kernel:
> 
>    text    data     bss     dec     hex filename
> 3352356  162812  218132 3733300  38f734 build/vmlinux
> 3347644  162648  217860 3728152  38e318 build-nhp/vmlinux
> 
> And that is about 5148 bytes.
> 
> In both cases the only difference is adding CONFIG_HOTPLUG=y to the
> config.
> 
> 5k isn't a lot, but in the context of 'I have to figure out how to
> trim ~1MB off the 3.6 kernel to run it in our smallest hardware' it is
> the wrong direction :(

It is only 0.138% in the "wrong" direction.  Seriously, that's a very
tiny percentage here, for an option that people _always_ get wrong, and
almost no system does not need.  The number of bugs we have had in this
area is huge, and by fixing this option like this, it takes them all
away.

Yes, there are going to be exceptions, like yours, that somehow do run
properly without CONFIG_HOTPLUG enabled.  But really, are you worried
about 0.138% right now?  The amount of time we just spent writing these
emails, memory sizes increased this much for your next platform, for the
same cost as your last platform.

Also, as you point out above, it's a constant number that this option is
affecting, which is good for you, because as time goes on, it's a
smaller and smaller percentage of the overall space used by your kernel.

Thanks for running the numbers, I appreciate it.  I'm amazed that your
kernel growth from 2.6.16 to 3.6 is 1Mb.  Why would you want to run the
3.6 kernel in a system designed for the 2.6.16 kernel (i.e. one designed
over 6 _years_ ago)?

A lot happens in 6 years :)

thanks,

greg k-h
