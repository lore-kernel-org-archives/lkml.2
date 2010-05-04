Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049Ab0EDRV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:21:27 -0400
Received: from kroah.org ([198.145.64.141]:53159 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760005Ab0EDRV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:21:26 -0400
Date: Tue, 4 May 2010 10:20:41 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Staging: RAR support - bring ready to move from staging
Message-ID: <20100504172041.GA20329@kroah.com>
References: <20100504105032.3de58e68@linux.intel.com>
 <20100504155112.GA26143@kroah.com>
 <20100504172704.77cdbeb8@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100504172704.77cdbeb8@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 05:27:04PM +0100, Alan Cox wrote:
> On Tue, 4 May 2010 08:51:12 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Tue, May 04, 2010 at 10:50:32AM +0100, Alan Cox wrote:
> > > 
> > > rar: perform a clean up pass
> > > 
> > > - Move to a registration model where each RAR is claimed/unclaimed
> > > - Use that to fix the client stuff (one client per RAR so no need
> > > to queue stuff)
> > > - Support unregister so drivers can rmmod themselves safely
> > > - Fix locking hang on calling rar lock from rar callback
> > > - Clean up
> > > - Kerneldoc
> > 
> > I get the following build errors with this patch:
> > 	  CC [M]  drivers/staging/memrar/memrar_handler.o
> > 	drivers/staging/memrar/memrar_handler.c: In function
> > ‘memrar_init’: drivers/staging/memrar/memrar_handler.c:910: warning:
> > passing argument 1 of ‘register_rar’ makes integer from pointer
> > without a cast
> 
> Expected - its a staging driver so I thought a patch that broke the API
> of another staging driver was fine (the second patch will fix it up)

Ah, those were two different drivers, that makes more sense.

It's not nice to break the build, I can't take a patch that is known to
do that, sorry.  Care to merge them together?

thanks,

greg k-h
