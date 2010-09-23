Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0IWEVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 00:21:06 -0400
Received: from kroah.org ([198.145.64.141]:40402 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab0IWEVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 00:21:04 -0400
Date: Wed, 22 Sep 2010 21:21:34 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, Anton Blanchard <anton@samba.org>,
        linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-09-22 - build error in drivers/staging/zram
Message-ID: <20100923042134.GA29818@kroah.com>
References: <201009222343.o8MNh9Mp023931@imap1.linux-foundation.org> <56264.1285212366@localhost> <20100922204305.2fdc5b66.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100922204305.2fdc5b66.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 08:43:05PM -0700, Andrew Morton wrote:
> On Wed, 22 Sep 2010 23:26:06 -0400 Valdis.Kletnieks@vt.edu wrote:
> 
> > On Wed, 22 Sep 2010 16:12:09 PDT, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2010-09-22-16-11 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > Looks like zram-free-percpu-data-on-module-exit.patch has issues:
> > 
> >   CC [M]  drivers/staging/zram/zram_drv.o
> > drivers/staging/zram/zram_drv.c: In function 'zram_reset_device':
> > drivers/staging/zram/zram_drv.c:500:2: error: incompatible type for argument 1 of 'free_percpu'
> > include/linux/percpu.h:153:13: note: expected 'void *' but argument is of type 'struct zram_stats'
> > make[3]: *** [drivers/staging/zram/zram_drv.o] Error 1
> > 
> 
> bah.  `make allmodconfig' enables CONFIG_STAGING_EXCLUDE_BUILD, so
> nothing under staging gets built.  Seems rather dumb.

That was done on purpose :)

> zram-free-percpu-data-on-module-exit.patch seems to be unneeded in the
> current zram driver - I'll drop the patch, thanks.

I'm waiting to see it all be hashed out, feel free to drop it.

thanks,

greg k-h
