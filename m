Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab2KSVt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 16:49:26 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:40006 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255Ab2KSVtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 16:49:25 -0500
Date: Mon, 19 Nov 2012 14:49:22 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Bill Pemberton <wfp5p@virginia.edu>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH 407/493] infiniband: remove use of __devexit
Message-ID: <20121119214922.GA5636@obsidianresearch.com>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
 <1353349642-3677-407-git-send-email-wfp5p@virginia.edu>
 <20121119200921.GD1556@obsidianresearch.com>
 <20121119201938.GA5614@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121119201938.GA5614@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 12:19:38PM -0800, Greg KH wrote:
> On Mon, Nov 19, 2012 at 01:09:21PM -0700, Jason Gunthorpe wrote:
> > On Mon, Nov 19, 2012 at 01:25:56PM -0500, Bill Pemberton wrote:
> > > CONFIG_HOTPLUG is going away as an option so __devexit is no
> > > longer needed.
> > 
> > I'm sad to hear this, it is an easy space saver on my non-modular
> > emebedded systems :(
> 
> Really?  I asked for details, and it was reported that this only saved
> 1-200 bytes or so.  See the lkml archives for the details of this.

I just checked for you:

Old 2.6.16 powerpc 32 kernel:

   text    data     bss     dec     hex filename
2399368  222224  156124 2777716  2a6274 build/vmlinux
2394634  221804  156124 2772562  2a4e52 build-nhp/vmlinux

That looks like around 5154 bytes to me

New 3.6 powerpc 32 kernel:

   text    data     bss     dec     hex filename
3352356  162812  218132 3733300  38f734 build/vmlinux
3347644  162648  217860 3728152  38e318 build-nhp/vmlinux

And that is about 5148 bytes.

In both cases the only difference is adding CONFIG_HOTPLUG=y to the
config.

5k isn't a lot, but in the context of 'I have to figure out how to
trim ~1MB off the 3.6 kernel to run it in our smallest hardware' it is
the wrong direction :(

Regards,
Jason
