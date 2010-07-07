Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab0GGVid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:38:33 -0400
Received: from kroah.org ([198.145.64.141]:48909 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757292Ab0GGVic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:38:32 -0400
Date: Wed, 7 Jul 2010 14:38:24 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] serial: fix termios settings in open
Message-ID: <20100707213824.GA3966@kroah.com>
References: <1277843500-14680-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277843500-14680-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 10:31:40PM +0200, Arnd Bergmann wrote:
> Move termios initialization in open into uart_dtr_rts to make sure
> it always gets called when necessary. Based on a suggestion from
> Alan Cox.
> 
> Alan writes:
> Ok this sort of makes sense. Something isn't getting initialised and both
> getty and minicom will do a termios set which is sorting it out.
> This is occurring because the generic block_til_ready sets
> ASYNCB_NORMAL_ACTIVE so the termios updating gets skipped.
> 
> This patch should cure it and then we can think about doing it more
> elegantly by getting the serial layer to use tty_port_open, kfifo and
> the like and removing the tons of repeated crap in all the drivers.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Tony Luck <tony.luck@intel.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Tony Luck <tony.luck@intel.com>
> ---
> 
> Greg, please apply to you tty series. I thought there was a bug
> in this patch but it turns out that this was incorrect. There
> is still something fishy on my system with hardware flow control,
> but it seems to be a preexisting condition, so this patch is actually
> good, unlike what I said before. Please apply next to "serial: Use
> block_til_ready helper", which introduces the ploblem.

Now applied, thanks.

greg k-h
