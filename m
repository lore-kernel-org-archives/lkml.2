Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab2K2ScL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 13:32:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:44795 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab2K2ScJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:32:09 -0500
Date: Thu, 29 Nov 2012 10:32:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: [Suggestion] drivers/tty: drivers/char/:  for
 MAX_ASYNC_BUFFER_SIZE
Message-ID: <20121129183207.GA4688@kroah.com>
References: <50B6E751.9000000@asianux.com>
 <20121129051335.GA4375@kroah.com>
 <50B6F967.3050000@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B6F967.3050000@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 01:57:59PM +0800, Chen Gang wrote:
> > And, I really don't understand here, why do you want to change this?
> > What is it going to change?  And why?
> > 
> 
> Why:
>   for the context MGSLPC_INFO *info in drivers/char/pcmcia/synclink_cs.c
>     info->max_frame_size can be the value between 4096 .. 65535 (can be
> set by its module input parameter)
>     info->flag_buf length is 4096 (MAX_ASYNC_BUFFER_SIZE)
>   in function rx_get_frame
>     the framesize is limit by info->max_frame_size, but may still be
> larger that 4096.
>     when call function ldisc_receive_buf, info->flag_buf is equal to
> 4096, but framesize can be more than 4096. it will cause memory over flow.

Do you use that pcmcia driver for anything?  Are those cards still
around?

> What:
>   #define MAX_ASYNC_BUFFER_SIZE  0x10000 (instead of 4096, originally).
>   let it match the max frame size.
> 
> At last:
>   my suggestion may be incorrect, need relative member (who expert about
> it) to help checking.

That driver might be incorrect, yes, care to make up a patch for it and
test it to verify it fixes the problem?

thanks,

greg k-h
