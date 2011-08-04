Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab1HDOkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 10:40:33 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46918 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883Ab1HDOkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 10:40:31 -0400
X-Sasl-enc: 4mG7Xm9tLJS6lsyb2LH/E3bic98hzW0R0M82ZoxCFadI 1312468830
Date: Thu, 4 Aug 2011 07:37:33 -0700
From: Greg KH <greg@kroah.com>
To: "MRU.Ilya" <utdilya@mail.ru>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: pty.c  in linux 2.6.31-rc5+
Message-ID: <20110804143733.GC18468@kroah.com>
References: <4E3A4053.6020107@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3A4053.6020107@mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 10:46:43AM +0400, MRU.Ilya wrote:
> Synchronic's line disciplines(ppp_synctty, hdlc) can't work with
> pseudo terminals.
> 
> If frames send very fast from one side(master/slave) to other one,
> frames merge in one (merge point "flip buffer") and the other side
> can read only one big frame.
> But sync line discipline need one frame in one read.
> 
> For push one frame to ldisc I propose small patch, but this regression for
> commit e043e42bdb66885b3ac10d27a01ccb9972e2b0a3.
> 
> I don't find any mutexes and other things forbidden in not user context,
> in function flush_to_ldisc() , and I think this patch
> is true and this function can called from any context. But I not sure.
> 
> Relative commit  86d23a057e718f73adc15e463c643d6e014a19cd.
> 
> 

> --- orig/pty.c	2011-07-13 07:29:43.000000000 +0400
> +++ work/pty.c	2011-08-03 20:59:01.000000000 +0400
> @@ -204,6 +204,7 @@
>  	clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
>  	set_bit(TTY_THROTTLED, &tty->flags);
>  	retval = 0;
> +	tty->low_latency = 1;

I really don't think this is correct.

Also, you forgot to read Documentation/SubmittingPatches for how to
properly format and send a patch and who to send it to...

thanks,

greg k-h
