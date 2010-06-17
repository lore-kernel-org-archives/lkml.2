Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab0FQUV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:21:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:48722 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933243Ab0FQUVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:21:23 -0400
Date: Thu, 17 Jun 2010 13:21:13 -0700
From: Greg KH <gregkh@suse.de>
To: Tony Luck <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 12/31] tty: serial - fix tty back references in termios
Message-ID: <20100617202113.GA20666@suse.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
 <1275425591-8803-13-git-send-email-arnd@arndb.de>
 <AANLkTik7PKE1Ch-15riGMzs9fL-4s_nTXrU2rh0yzq0I@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik7PKE1Ch-15riGMzs9fL-4s_nTXrU2rh0yzq0I@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 11:50:57AM -0700, Tony Luck wrote:
> A couple of build breaks in linux-next (tag: next-20100617)
> 
> drivers/serial/ioc4_serial.c:1750: error: expected statement before ‘)’ token
> 
> Would have a similar one for ioc3_serial.c if my .config included it.
> 
> On Tue, Jun 1, 2010 at 1:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > diff --git a/drivers/serial/ioc3_serial.c b/drivers/serial/ioc3_serial.c
> > index f164ba4..bd2e9e6 100644
> > --- a/drivers/serial/ioc3_serial.c
> > +++ b/drivers/serial/ioc3_serial.c
>  ...
> > -       if (I_IGNPAR(state->port.tty))
> > +       if (iflag & IGNPAR))
> 
> Can we have matching numbers of "(" and ")" here please.
> 
> > diff --git a/drivers/serial/ioc4_serial.c b/drivers/serial/ioc4_serial.c
> > index 8ad28fc..2c30023 100644
> > --- a/drivers/serial/ioc4_serial.c
> > +++ b/drivers/serial/ioc4_serial.c
>  ..
> .-               if (I_IGNPAR(state->port.tty))
> +               if (iflag & IGNPAR))
> 
> Same here.

I've fixed these up in my tree so the next linux-next will contain the
correct ones.

thanks,

greg k-h
