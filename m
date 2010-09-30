Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab0I3UCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:02:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab0I3UCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:02:31 -0400
Date: Thu, 30 Sep 2010 12:53:07 -0700
From: Greg KH <gregkh@suse.de>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: Greg KH <greg@kroah.com>, kernel-janitors@vger.kernel.org,
        devel@driverdev.osuosl.org, Marek Belisko <marek.belisko@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ft1000: fix skb, netdev, memory leaks
Message-ID: <20100930195307.GA30952@suse.de>
References: <1285696175-5654-1-git-send-email-segooon@gmail.com>
 <20100930111345.GA9978@kroah.com>
 <20100930192303.GA10342@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100930192303.GA10342@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 11:23:03PM +0400, Vasiliy Kulikov wrote:
> On Thu, Sep 30, 2010 at 04:13 -0700, Greg KH wrote:
> > On Tue, Sep 28, 2010 at 09:49:35PM +0400, Vasiliy Kulikov wrote:
> > > ft1000_copy_up_pkt() doesn't free skb on errors.
> > > init_ft1000_card() doesn't free netdev with free_netdev() but with kfree().
> > > init_ft1000_card() doesn't check request_region()'s return value
> > > and doesn't free region on error.
> > > 
> > > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> > > ---
> > >  Compile tested.
> > 
> > No you didn't
> 
> No I did:
> 
> make -C /home/vasya/linux drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.o
> make: Вход в каталог `/home/vasya/dev/linux-next'
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CC      drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.o
> drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c: In function ‘ft1000_reset_card’:
> drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:525: warning: passing argument 2 of ‘card_download’ discards qualifiers from pointer target type
> drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:56: note: expected ‘void *’ but argument is of type ‘const u8 * const’
> make: Выход из каталога `/home/vasya/dev/linux-next'

Heh, I didn't think to try that, amazed that it worked at all.

> However, 
> 
>     cd ../drivers/staging/ft1000/ft1000-pcmcia/
>     LANG=C make -C ~/linux ft1000_hw.o
>     make: Entering directory `/home/vasya/dev/linux-next'
>     make: *** No rule to make target `ft1000_hw.o'.  Stop.
>     make: Leaving directory `/home/vasya/dev/linux-next'
> 
> 
> Is "make" from linux root buggy/not supported for staging/everything?

This driver is marked broken, look at the Kconfig file:
	config FT1000_PCMCIA
	        tristate "Driver for ft1000 pcmcia device."
	        depends on PCMCIA && BROKEN


It will be fixed up soon hopefully.

thanks,

greg k-h
